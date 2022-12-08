using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.Services;

namespace DanhSachSinhVien
{
    public partial class DanhSachSinhVien : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                PopulateList();
            }
        }
        private void PopulateList()
        {
            StudentListSQLDataContext db = new StudentListSQLDataContext();
            StudentListGridView.DataSource = db.StudentLists;
            StudentListGridView.DataBind();
        }
        [WebMethod]
        public static bool DeleteStudent(int StudentId)
        {
            string conString = ConfigurationManager.ConnectionStrings["DanhSachSinhVienConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand("DELETE FROM StudentList WHERE StudentId = @StudentId"))
                {
                    cmd.Connection = con;
                    cmd.Parameters.AddWithValue("@StudentId", StudentId);
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();
                    return rowsAffected > 0;
                }
            }

        }
        [WebMethod]
        public static bool InsertStudent(string FullName, string PhoneNumber, int Age, string Address)
        {
            string command = "INSERT into StudentList values(N'" + FullName + "', '" + PhoneNumber + "',N'" + Address + "','" + Age + "')";
            string conString = ConfigurationManager.ConnectionStrings["DanhSachSinhVienConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand(command))
                {
                    cmd.Connection = con;
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();
                    return rowsAffected > 0;
                }
            }
        }
        [WebMethod]
        public static string PreviewStudent(int StudentId)
        {
            string data = string.Empty;
            try
            {
                using (StudentListSQLDataContext db = new StudentListSQLDataContext())
                {
                    var obj = db.StudentLists.FirstOrDefault(x => x.StudentId == StudentId);
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    data = serializer.Serialize(obj);
                }
                return data;
            }
            catch
            {
                return data;
            }
        }
        [WebMethod]
        public static bool UpdateStudent(int StudentId, string FullName, string PhoneNumber, int Age, string Address)
        {
            string command = "UPDATE StudentList SET FullName = N'" + FullName + "', PhoneNumber = '" + PhoneNumber + "', Address = N'" + Address + "', Age = '" + Age + "' WHERE StudentId = '" + StudentId + "'";
            string conString = ConfigurationManager.ConnectionStrings["DanhSachSinhVienConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand(command))
                {
                    cmd.Connection = con;
                    con.Open();
                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();
                    return rowsAffected > 0;
                }
            }
        }
    }
}