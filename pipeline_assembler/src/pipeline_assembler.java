
import java.util.Scanner;
import java.io.*;

public class pipeline_assembler {
    public static void main(String [] args) {
        String inpStr = "";
        String machineCode;
        String loadIndex;
        String immediate;
        String rd;
        String rs3;
        String rs2;
        String rs1;

        String translatedMachineCodeInstr = "";

        Scanner stdin = new Scanner(System.in);
        Scanner fileIn;

        System.out.print("Input file name: ");
        String fileName = stdin.nextLine();

        try {
            fileIn = new Scanner(new File(fileName));
            while (fileIn.hasNextLine()) {

                inpStr = fileIn.nextLine().toLowerCase();
                String[] mipsCode = inpStr.split("[ ,]+");
                machineCode = "";
                if (mipsCode[0].equals("li")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    loadIndex = strIntToStrBinary(mipsCode[2], 3);
                    immediate = strIntToStrBinary(mipsCode[3], 16);
                    machineCode = "0" + loadIndex + immediate + rd;
                } else if (mipsCode[0].equals("imal")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "000" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("imah")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "001" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("imsl")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "010" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("imsh")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "011" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("lmal")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "100" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("lmah")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "101" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("lmsl")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "110" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("lmsh")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    rs3 = strIntToStrBinary(mipsCode[4], 5);
                    machineCode = "10" + "111" + rs3 + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("nop")) {
                    rs2 = "00000";
                    rs1 = "00000";
                    rd = "00000";
                    machineCode = "11" + "00000000" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("ah")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000001" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("ahs")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000010" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("bcw")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000011" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("cgh")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000100" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("clz")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000101" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("max")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000110" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("min")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00000111" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("msgn")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001000" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("popcnth")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001001" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("rot")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001010" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("rotw")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001011" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("shlhi")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001100" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("sfh")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001101" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("sfhs")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001110" + rs2 + rs1 + rd;
                } else if (mipsCode[0].equals("xor")) {
                    rd = strIntToStrBinary(mipsCode[1], 5);
                    rs1 = strIntToStrBinary(mipsCode[2], 5);
                    rs2 = strIntToStrBinary(mipsCode[3], 5);
                    machineCode = "11" + "00001111" + rs2 + rs1 + rd;
                }

                if (machineCode.length() != 25) {
                    System.out.println("Something went wrong");
                } else {
                    translatedMachineCodeInstr += machineCode + "\n";
                }

            }

        }
        catch (FileNotFoundException e) {
            System.out.println("File not found");
        }

        try{
            File output = new File("translatedMIPSCode.txt");
            PrintWriter pw = new PrintWriter(output);

            //write to file
            pw.print(translatedMachineCodeInstr);
            System.out.println("mips program has been translated to machine " +
                            "code and saved to \"translatedMIPSCode.txt\"");

            pw.close();
        }
        catch(FileNotFoundException e){
            System.out.println("Unable to write");
        }

    }

    public static String strIntToStrBinary(String number, int numberOfBits){
        String strInt =
                Integer.toBinaryString( (1 << numberOfBits) | Integer.parseInt(number) ).substring( 1 );
        return strInt;
    }


}
