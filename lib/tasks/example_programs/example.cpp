#include <iostream>

using namespace std;

int add(int a, int b)
{
	return a + b;
}

int main(int argc, char* argv[])
{
	int a, b;
	cin >> a;
	cin >> b;
	cout << add(a,b) << endl;
	return 0;
}
