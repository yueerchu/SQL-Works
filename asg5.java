
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLWarning;
import java.util.Scanner;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import javax.swing.JOptionPane;
import javax.swing.JPasswordField;
import java.util.ArrayList;
/**
 * Microsoft SQL Server JDBC test program5 Demonstrates a nested cursor loop
 * with dynamic sql queries Retrieves dependent names of employees who work for
 * a specific department (department name) from the user given database
 */
public class asg5 {
	static private boolean debug = true;

	public asg5() throws Exception {
            String fileName, url, databaseName, username, password, projnum;
            double sum = 0.0;
            int time = 0;
            JPasswordField pass = new JPasswordField();
            JOptionPane.showMessageDialog(null, pass, "Enter SQL Password",
			JOptionPane.INFORMATION_MESSAGE);
            password = new String(pass.getPassword());

            Scanner console = new Scanner(System.in);
            System.out.print("Enter hostname (e.g. localhost): ");
            url = console.nextLine();
            System.out.print("Enter database name: ");
            databaseName = console.nextLine();
            url = "jdbc:jtds:sqlserver://" + url + ":1433/" + databaseName;
            System.out.print("Enter username: ");
            username = console.nextLine();

            // Get connection
            DriverManager.registerDriver(new net.sourceforge.jtds.jdbc.Driver());
            Connection connection = DriverManager.getConnection(url, username,
			password);
            if (connection != null) {
		System.out.println();
		System.out.println("Successfully connected to DB: " + username);
		System.out.println();
                String outerQuery = "SELECT project.pname, department.dname, employee.fname, employee.lname, count(works_on.pno) "
				+ "FROM project, department, employee, works_on "
				+ "WHERE project.pnumber = ? and project.dnum = department.dnumber and employee.ssn = department.mgrssn and works_on.pno = project.pnumber "
                                + "group by project.pname, department.dname, employee.fname, employee.lname";
		PreparedStatement stmt1 = connection.prepareStatement(outerQuery);
		


                System.out.print("Enter input file name: ");
                fileName = console.nextLine();
                System.out.println("\nOutput: \n");
                System.out.println("Proj#	ProjName	  Department	     Manager		# of assignments");
                System.out.println("-------	-------------     ---------------    --------------	----------------");
                try {
                    File file = new File(fileName);
                    Scanner scanner = new Scanner(file);
                    while (scanner.hasNext()) {
               		projnum = scanner.nextLine();
                        stmt1.clearParameters();
			stmt1.setString(1, projnum); 
			ResultSet rs1 = stmt1.executeQuery();
                       
                        if (rs1.next()) {
                            
                            String projectName = rs1.getString(1);
                            String depName = rs1.getString(2);
                            String name = rs1.getString(3) + " " + rs1.getString(4);
                            String numofassign = rs1.getString(5);
                            double number = Double.parseDouble(numofassign);
                            sum = sum + number;
                            time = time + 1;
                            
                            System.out.printf("%-8s",projnum);
                            System.out.printf("%-18s",projectName);
                            System.out.printf("%-19s",depName);
                            System.out.printf("%-26s",name);
                            System.out.printf("%-40s\n",numofassign);
                        } else {
                            System.out.println("Invalid input project number: " + projnum);
                        }
                    }
                    System.out.println("\nThe average number of work assignments per valid project is: " + (sum/time));
                    scanner.close();
                    stmt1.close();
                    connection.close();

                } catch (FileNotFoundException e) {
                	e.printStackTrace();
                }
            }
        }
        
        public static void main(String args[]) throws Exception {
		asg5 test = new asg5();
		System.exit(0);
	}
}