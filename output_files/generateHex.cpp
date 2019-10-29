//Test cpp file to generate a quick hex markup for verilog datapath test.
#include <fstream>
#include <iostream>
using namespace std;

int main(){
    ofstream outputFile("..\\initialHex.dat");
    int currentNum = 0;
    if(outputFile.is_open()){
        while(currentNum <= 65535){
            outputFile << hex << (currentNum + 1) << endl;
            currentNum++;
        }
    }
    outputFile.close();
    return 0;
}