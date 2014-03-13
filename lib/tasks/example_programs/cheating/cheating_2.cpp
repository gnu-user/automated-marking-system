#include <iostream>

using namespace std;

int main(int argc, char* argv[])
{
	int x, y;
	cin >> x;
	cin >> y;
	cout << add(x, y) << endl;
	return 0;
}

int add(int x, int y)
{
	return x + y;
}
