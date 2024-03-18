using Microsoft.Data.SqlClient;
using System.Data;
using System.Windows.Forms;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        private SqlConnection dbConnection = new SqlConnection("Data Source=DESKTOP-LQ4HQV4\\SQLEXPRESS;Initial Catalog=VeganFoodStore;Integrated Security=True;Trusted_Connection=True;TrustServerCertificate=True");
        private SqlDataAdapter daProducts = new SqlDataAdapter(), daSuppliers = new SqlDataAdapter();
        private DataSet tableData = new DataSet();


        public Form1()
        {
            InitializeComponent();
            dataGridView1.SelectionChanged += dataGridView1_SelectionChanged;
            dataGridView2.SelectionChanged += dataGridView2_SelectionChanged;

        }

        private void button4_Click(object sender, EventArgs e)
        {
            daProducts.SelectCommand = new SqlCommand("SELECT * FROM Products", dbConnection);
            tableData.Clear();
            daProducts.Fill(tableData, "Products");
            dataGridView1.DataSource = tableData.Tables["Products"];

            daSuppliers.SelectCommand = new SqlCommand("SELECT * FROM Supplier", dbConnection);
            daSuppliers.Fill(tableData, "Supplier");
            dataGridView2.DataSource = tableData.Tables["Supplier"];

        }

        // load tablew view 1
        private void ReloadProductsTableView()
        {
            if (tableData.Tables["Products"] != null)
            {
                tableData.Tables["Products"].Clear();
            }
            daProducts.Fill(tableData, "Products");
        }

        // select Product from products view
        private void dataGridView1_SelectionChanged(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count > 0)
            {
                DataGridViewRow selectedRow = dataGridView1.SelectedRows[0];
                textBox1.Text = selectedRow.Cells[0].Value.ToString();
                textBox2.Text = selectedRow.Cells[1].Value.ToString();
                textBox3.Text = selectedRow.Cells[2].Value.ToString();
                textBox4.Text = selectedRow.Cells[3].Value.ToString();
                textBox5.Text = selectedRow.Cells[4].Value.ToString();
            }
        }

        // display Products that have a certain supplier
        private void dataGridView2_SelectionChanged(object sender, EventArgs e)
        {
            textBox1.Clear();
            textBox2.Clear();
            textBox3.Clear();
            textBox4.Clear();
            textBox5.Clear();

            if (dataGridView2.SelectedRows.Count > 0)
            {
                DataGridViewRow selectedRow = dataGridView2.SelectedRows[0];
                daProducts.SelectCommand = new SqlCommand("SELECT * from Products WHERE SupplierId = " + selectedRow.Cells[0].Value, dbConnection);
                ReloadProductsTableView();
            }
        }


        private void label5_Click(object sender, EventArgs e)
        {

        }


        private void dataGridView1_CellContentClick(object sender, DataGridViewCellEventArgs e)
        {


        }

        //add product
        private void button1_Click(object sender, EventArgs e)
        {
            SqlCommand command = new SqlCommand("INSERT INTO Products (ProductId,Name, Price, SupplierId, PromotionId) VALUES (@ProductId ,@Name , @Price, @SupplierId, @PromotionId)", dbConnection);
            if (textBox1.Text.Length > 0)
            {
                try
                {
                    int product_id = Int32.Parse(textBox1.Text);

                    if (textBox4.Text.Length > 0 && textBox5.Text.Length > 0)
                    {
                        int supplier_id = Int32.Parse(textBox4.Text);
                        int promotion_id = Int32.Parse(textBox5.Text);
                        int price = Int32.Parse(textBox3.Text);


                        command.Parameters.Add("@ProductId", SqlDbType.Int);

                        command.Parameters["@ProductId"].Value = product_id;


                        command.Parameters.Add("@SupplierId", SqlDbType.Int);
                        command.Parameters["@SupplierId"].Value = supplier_id;

                        command.Parameters.Add("@PromotionId", SqlDbType.Int);
                        command.Parameters["@PromotionId"].Value = promotion_id;

                        command.Parameters.Add("@Name", SqlDbType.VarChar, 50);
                        command.Parameters["@Name"].Value = textBox2.Text;

                        command.Parameters.Add("@Price", SqlDbType.Int);
                        command.Parameters["@Price"].Value = price;
                        try
                        {
                            dbConnection.Open();
                            daProducts.InsertCommand = command;
                            daProducts.InsertCommand.ExecuteNonQuery();
                            ReloadProductsTableView();
                            dbConnection.Close();
                        }
                        catch (SqlException ex)
                        {
                            MessageBox.Show(ex.Message);
                            dbConnection.Close();
                        }

                    }
                    else
                        if (textBox4.Text.Length == 0)
                    {
                        MessageBox.Show("Please provide a supplier id!");
                    }
                    else if (textBox5.Text.Length == 0)
                    {
                        MessageBox.Show("Please provide a promotion id!");
                    }
                }
                catch (SqlException sqlException)
                {
                    MessageBox.Show(sqlException.ToString());
                }
            }

            else
                MessageBox.Show("Please provide an product id!");

        }

        private void button2_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count > 0)
            {

                int productId = (int)dataGridView1.SelectedRows[0].Cells["ProductId"].Value;
                SqlCommand deleteCommand = new SqlCommand("DELETE FROM Products WHERE ProductId = @ProductId", dbConnection);


                deleteCommand.Parameters.AddWithValue("@ProductId", productId);

                try
                {
                    dbConnection.Open();
                    deleteCommand.ExecuteNonQuery();
                    MessageBox.Show("Product deleted successfully!");
                    ReloadProductsTableView();
                }
                catch (SqlException ex)
                {
                    MessageBox.Show("Error deleting product: " + ex.Message);
                }
                finally
                {
                    dbConnection.Close();
                }
            }
            else
            {
                MessageBox.Show("Please select a product to delete.");
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (dataGridView1.SelectedRows.Count > 0)
            {
                
                int productId = (int)dataGridView1.SelectedRows[0].Cells["ProductId"].Value;

                SqlCommand updateCommand = new SqlCommand("UPDATE Products SET Name = @Name, Price = @Price, SupplierId = @SupplierId, PromotionId = @PromotionId WHERE ProductId = @ProductId", dbConnection);

                
                updateCommand.Parameters.AddWithValue("@Name", textBox2.Text);
                updateCommand.Parameters.AddWithValue("@Price", Convert.ToInt32(textBox3.Text));
                updateCommand.Parameters.AddWithValue("@SupplierId", Convert.ToInt32(textBox4.Text));
                updateCommand.Parameters.AddWithValue("@PromotionId", Convert.ToInt32(textBox5.Text));
                updateCommand.Parameters.AddWithValue("@ProductId", productId);

                
                try
                {
                    dbConnection.Open();
                    updateCommand.ExecuteNonQuery();
                    ReloadProductsTableView();
                }
                catch (SqlException ex)
                {
                    MessageBox.Show("Error updating product: " + ex.Message);
                }
                finally
                {
                    dbConnection.Close();
                }
            }
            else
            {
                MessageBox.Show("Please select a product to update.");
            }
        }
    }
}