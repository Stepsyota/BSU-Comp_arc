/*
8.1 Реализуйте измерение среднего времени доступа к кэш-памяти для раз-
ных значений byte_size (от 1 КБ до 128 МБ) и stride (от 1 до 32) используя
циклическую цепочку указателей (линейную и рандомизированную). Резуль-
таты измерений сохраните в файл в формате CSV (Comma-separated values): в
каждой строке по три значения отделенных запятыми
(byte_size,stride,time). Используя сторонние приложения (Excel, Matlab,
Gnuplot и т. п.), по сохраненным данным постройте график зависимости
time(byte_size, stride). По характерным ступенькам на графике оцените
размер каждого уровня кэш-памяти. Узнайте значения размеров уровней кэша
вашего процессора средствами операционной системы или из документации в
интернет. Сравните с экспериментальной оценкой

8.2 Используя найденные размеры уровней кэш памяти, экспериментально
оцените пропускную способность каждого уровня в ГБ / с. Для этого выпол-
ните копирование массива, размер которого точно совпадает с размером вы-
бранного уровня кэша. Для копирования байтов можно воспользоваться стан-
дартной функцией memcpy() из заголовка cstring.
*/

#include <iostream>
#include <chrono>
#include <fstream>
#include <vector>

using namespace std;

void** create_linear_chain(size_t, size_t);
void** create_random_chain(size_t, size_t);
double measure_access_time(void**, size_t);

int main() {
	std::ofstream csv_file("cache_table.csv");
	csv_file << "Byte_size,Stride,Time,Chain_type\n";

	size_t iterations = int(10e4);

	size_t byte_size = 1024;
	size_t stride = 1;
	size_t max_byte_size = 128 * 1024 * 1024;

	while (stride <= 32) {
		while (byte_size <= max_byte_size) {
			void** linear_chain = create_linear_chain(byte_size, stride);
			double linear_time = measure_access_time(linear_chain, iterations);
			csv_file << byte_size << ", " << stride << ", " << linear_time << ", " << "linear\n";
			cout << "Byte size = " << byte_size << "\t Stride = " << stride << "\t Time = " << linear_time << " ns,\t Chain = linear" << endl;
			delete[] linear_chain;


			void** random_chain = create_random_chain(byte_size, stride);
			double random_time = measure_access_time(random_chain, iterations);
			csv_file << byte_size << ", " << stride << ", " << random_time << ", " << "random\n";
			cout << "Byte size = " << byte_size << "\t Stride = " << stride << "\t Time = " << linear_time << " ns,\t Chain = random" << endl;
			delete[] random_chain;
			byte_size *= 2;
		}
		stride += 1;
		byte_size = 1024;
	}

	csv_file.close();
	return 0;
}

void** create_linear_chain(size_t byte_size, size_t stride) {
	size_t len = byte_size / sizeof(void*);
	void** buf = new void* [len];
	size_t n = len / stride;
	for (size_t i = 1; i < n; ++i)
	{
		buf[(i - 1) * stride] = &buf[i * stride];
	}
	buf[(n - 1) * stride] = &buf[0 * stride];
	return buf;
}

void** create_random_chain(size_t byte_size, size_t stride) {
	size_t len = byte_size / sizeof(void*);
	void** buf = new void* [len];
	size_t n = len / stride;

	vector<size_t> rand_iter(n);
	for (size_t i = 0; i < n; ++i) {
		rand_iter[i] = i;
	}


	for (size_t i = 1; i < n; ++i)
	{
		buf[(i - 1) * stride] = &buf[i * stride];
	}
	buf[(n - 1) * stride] = &buf[0 * stride];
	return buf;
}

double measure_access_time(void** buf, size_t count) {

	size_t count_warm = 1000;
	void** t = (void**)buf[0];
	while (count_warm-- > 0) {
		t = (void**)*t;
	}

	auto start_time = std::chrono::high_resolution_clock::now();

	void** p = (void**)buf[0];
	while (count-- > 0) {
		p = (void**)*p;
	}
	if (time(nullptr) == 0) cout << p;
	
	auto end_time = std::chrono::high_resolution_clock::now();
	std::chrono::duration<double, std::nano> elapsed = end_time - start_time;
	return elapsed.count() / count;
}