﻿using ATBM_Project.ViewsModels;
using Oracle.ManagedDataAccess.Client;
using System.Windows;

namespace ATBM_Project.Views.Employee
{
    /// <summary>
    /// Interaction logic for EmployeePage.xaml
    /// </summary>

    public partial class EmployeePage : Window
    {
        private string _userName { get; set; }
        private OracleConnection _connection;
        private Employee_VM employee_VM;

        public EmployeePage(OracleConnection connection, string userName)
        {
            _userName = userName;
            _connection = connection;
            InitializeComponent();
            Title.Text = _userName;
            employee_VM = new Employee_VM(connection);
        }

        public void clickBack(object sender, RoutedEventArgs e)
        {
            _connection.Close();
            Login_View login = new Login_View();
            this.Close();
            login.Show();
        }

        private void infoButton_Click(object sender, RoutedEventArgs e)
        {
            UserController.Content = new EmployeeInfo(employee_VM);
        }

        private void studentButton_Click(object sender, RoutedEventArgs e)
        {
            UserController.Content = new Student_View();
        }

        private void compartmentButton_Click(object sender, RoutedEventArgs e)
        {
            UserController.Content = new Unit_View();
        }

        private void moduleButton_Click(object sender, RoutedEventArgs e)
        {
            UserController.Content = new Course_View();
        }

        private void courseButton_Click(object sender, RoutedEventArgs e)
        {
            UserController.Content = new CourseOpen_View();
        }
    }
}
