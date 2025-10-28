#include <iostream>
#include <chrono>
#include <fstream>
#include <vector>
#include <algorithm>
#include <random>
#include <numeric>
#include <thread>

#ifdef _WIN32
#include <windows.h>
#endif

using namespace std;

// Function prototypes
void** create_linear_chain(size_t byte_size, size_t stride);
void** create_random_chain(size_t byte_size, size_t stride);
double measure_access_time(void** buf, size_t iterations);
void flush_cache();
void pin_to_core(int core_id);

int main() {
    // Pin the program to a single CPU core for more stable results
    pin_to_core(0);

    ofstream csv_file("cache_table.csv");
    csv_file << "Byte_size,Stride,Time,Chain_type\n";

    const size_t max_byte_size = 128 * 1024 * 1024; // 128 MB
    // Strides are expressed in bytes (typical cache line size = 64 bytes)
    const vector<size_t> strides = { 64, 128, 256, 512, 1024, 2048, 4096, 8192 };

    for (size_t stride : strides) {
        cout << "\n=== STRIDE = " << stride << " bytes ===" << endl;

        for (size_t byte_size = 1024; byte_size <= max_byte_size; byte_size *= 2) {

            // --- Linear pointer chain ---
            void** linear_chain = create_linear_chain(byte_size, stride);

            // Flush CPU caches to remove leftovers from previous tests
            flush_cache();

            // Adjust number of iterations to keep runtime stable
            size_t iterations = max((size_t)1, (size_t)(100000000 / (byte_size / 1024)));

            // Measure average access time (ns)
            double linear_time = measure_access_time(linear_chain, iterations);

            csv_file << byte_size << "," << stride << "," << linear_time << ",linear\n";
            cout << "Size = " << (byte_size / 1024) << " KB"
                << "\tAverage = " << linear_time << " ns" << endl;

            delete[] linear_chain;

            // --- Randomized pointer chain ---
            void** random_chain = create_random_chain(byte_size, stride);
            flush_cache();

            double random_time = measure_access_time(random_chain, iterations);
            csv_file << byte_size << "," << stride << "," << random_time << ",random\n";

            delete[] random_chain;
        }
    }

    csv_file.close();
    cout << "\nResults saved to cache_table.csv" << endl;
    return 0;
}

/**
 * Create a linear pointer chain where each element points to the next one
 * separated by a given stride. The last element points back to the first.
 */
void** create_linear_chain(size_t byte_size, size_t stride) {
    size_t len = byte_size / sizeof(void*);
    void** buf = new void* [len];
    size_t n = len / (stride / sizeof(void*));
    if (n < 2) n = 2;

    for (size_t i = 0; i < n; ++i) {
        buf[(i * stride / sizeof(void*)) % len] =
            &buf[((i + 1) * stride / sizeof(void*)) % len];
    }
    return buf;
}

/**
 * Create a randomized pointer chain (to disable prefetching effects).
 * Each pointer leads to a random next address within the array.
 */
void** create_random_chain(size_t byte_size, size_t stride) {
    size_t len = byte_size / sizeof(void*);
    void** buf = new void* [len];
    size_t n = len / (stride / sizeof(void*));
    if (n < 2) n = 2;

    vector<size_t> indices(n);
    iota(indices.begin(), indices.end(), 0);
    shuffle(indices.begin(), indices.end(), mt19937(random_device{}()));

    for (size_t i = 0; i < n; ++i) {
        buf[indices[i] * (stride / sizeof(void*)) % len] =
            &buf[indices[(i + 1) % n] * (stride / sizeof(void*)) % len];
    }
    return buf;
}

/**
 * Measure average pointer dereference time (in nanoseconds).
 * Uses high-resolution clock and performs warm-up iterations first.
 */
double measure_access_time(void** buf, size_t iterations) {
    void* p = buf;

    // Warm-up phase to pre-load TLB and avoid first-access penalties
    for (size_t i = 0; i < 10000; ++i)
        p = *(void**)p;

    // Timing loop
    auto start_time = chrono::high_resolution_clock::now();
    for (size_t i = 0; i < iterations; ++i)
        p = *(void**)p;
    auto end_time = chrono::high_resolution_clock::now();

    chrono::duration<double, nano> elapsed = end_time - start_time;
    return elapsed.count() / iterations;
}

/**
 * Allocate and touch a large buffer to flush all cache levels (L1-L3).
 * This helps to avoid inter-test cache interference.
 */
void flush_cache() {
    const size_t size = 32 * 1024 * 1024; // 32 MB
    char* dummy = new char[size];
    for (size_t i = 0; i < size; i += 64)
        dummy[i] = static_cast<char>(i);
    delete[] dummy;
}

/**
 * Pin the current process/thread to a specific CPU core.
 * This avoids migration between cores, ensuring cache locality.
 */
void pin_to_core(int core_id) {
#ifdef _WIN32
    // Windows implementation
    SetThreadAffinityMask(GetCurrentThread(), 1ull << core_id);
#else
    // POSIX/Linux implementation
    cpu_set_t cpuset;
    CPU_ZERO(&cpuset);
    CPU_SET(core_id, &cpuset);
    pthread_setaffinity_np(pthread_self(), sizeof(cpu_set_t), &cpuset);
#endif
}
