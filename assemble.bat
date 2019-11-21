echo "Running assembly program. Make sure all values wanted are stored in explode.asm"
python ./assembler.py
xcopy /y explode.dat .\explode.dat
xcopy /y explode.dat .\simulation\explode.dat
xcopy /y explode.dat .\simulation\modelsim\explode.dat
echo "Done"