#include <iostream>

using namespace std;

// Adds two numbers together
int add_numbers(int val1, int val2);

int main()
{
	// Get input from the user
  int val1 = 0, val2 = 0;	
  cout << "Enter the first value: ";  
  cin >> val1;
  cout << "Enter the second value: ";
	cin >> val2;

  // Add the numbers
	cout << "Numbers added: " << add_numbers(val1, val2) << endl;
	return 0;
}

int add_numbers(int val1, int val2)
{
	return val1 + val2;
}
