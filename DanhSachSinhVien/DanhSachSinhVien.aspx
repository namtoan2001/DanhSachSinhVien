<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="DanhSachSinhVien.aspx.cs" Inherits="DanhSachSinhVien.DanhSachSinhVien" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8">
    <title></title>
    <script src="Scripts/jquery-3.6.1.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $("[id*=StudentListGridView] [id*=lnkDelete]").click(function () {
                if (confirm("Bạn có muốn xóa không?")) {

                    var row = $(this).closest("tr");
                    var StudentId = parseInt(row.find("[id*=hfStudentId]").val());

                    $.ajax({
                        type: "POST",
                        url: "DanhSachSinhVien.aspx/DeleteStudent",
                        data: '{StudentId: ' + StudentId + '}',
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: function (r) {
                            if (r.d) {
                                row.remove();
                                if ($("[id*=StudentListGridView] td").length == 0) {
                                    $("[id*=StudentListGridView] tbody").append("<tr><td colspan = '4' align = 'center'>Không có dữ liệu được tìm thấy.</td></tr>")
                                }
                                alert("Xóa thành công");
                                clear();
                            }
                        }
                    });
                }
                return false;
            });
        });
    </script>
    <script type="text/javascript">
        $(function () {
            $("[id*=StudentListGridView] [id*=lnkUpdate]").click(function () {
                var row = $(this).closest("tr");
                var StudentId = parseInt(row.find("[id*=hfStudentId]").val());
                $.ajax({
                    type: "POST",
                    url: "DanhSachSinhVien.aspx/PreviewStudent",
                    data: '{StudentId: ' + StudentId + '}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    async: false,
                    success: function (r) {
                        var msg = eval('(' + r.d + ')');
                        $('#txtFullName').val(msg.FullName);
                        $('#txtPhoneNumber').val(msg.PhoneNumber);
                        $('#txtAge').val(msg.Age);
                        $('#txtAddress').val(msg.Address);
                        $('#hfStudentId').val(StudentId);
                        $('#hfId').val(StudentId);
                        window.location.reload();
                        $("#AddNew").hide();
                    }
                });
            })
        })
    </script>
    <script type="text/javascript">  
        $(document).ready(function () {
            $('#AddNew').click(function () {
                var errCount = validateData();
                if (errCount == 0) {
                    $.ajax({
                        type: 'POST',
                        contentType: "application/json; charset=utf-8",
                        url: 'DanhSachSinhVien.aspx/InsertStudent',
                        data: "{'FullName':'" + document.getElementById('txtFullName').value
                            + "', 'PhoneNumber':'" + document.getElementById('txtPhoneNumber').value
                            + "', 'Age':'" + document.getElementById('txtAge').value
                            + "', 'Address':'" + document.getElementById('txtAddress').value
                            + "'}",
                        async: false,
                        success: function (response) {
                            $('#txtFullName').val('');
                            $('#txtPhoneNumber').val('');
                            $('#txtAge').val('');
                            $('#txtAddress').val('');
                            alert("Thêm thành công!");
                            window.location.reload();
                            clear();
                        },
                        error: function () {
                            console.log('there is some error');
                        }
                    });
                }
            });
        });
        $(document).ready(function () {
            $('#Update').click(function () {
                var errCount = validateData();
                /*var row = $(this).closest("tr");*/
                var StudentId = $("#hfId").val();
                if (errCount == 0) {
                    $.ajax({
                        type: 'POST',
                        contentType: "application/json; charset=utf-8",
                        url: 'DanhSachSinhVien.aspx/UpdateStudent',
                        data: "{'StudentId':'" + StudentId
                            + "', 'FullName':'" + document.getElementById('txtFullName').value
                            + "', 'PhoneNumber':'" + document.getElementById('txtPhoneNumber').value
                            + "', 'Age':'" + document.getElementById('txtAge').value
                            + "', 'Address':'" + document.getElementById('txtAddress').value
                            + "'}",
                        async: false,
                        success: function (response) {
                            $('#txtFullName').val('');
                            $('#txtPhoneNumber').val('');
                            $('#txtAge').val('');
                            $('#txtAddress').val('');
                            alert("Cập nhật thành công!");
                        },
                        error: function () {
                            console.log('there is some error');
                        }
                    });
                }
            });
        });
        function validateData() {
            var txtFullName = $("#txtFullName").val();
            var txtPhoneNumber = $("#txtPhoneNumber").val();
            var txtAddress = $("#txtAddress").val();
            var txtAge = $("txtAge").val();
            var errMsg = "";
            var errCount = 0;
            if (txtFullName.length <= 0) {
                errCount++;
                
                alert("Vui lòng nhập họ tên.")
            }
            else if (txtPhoneNumber.length <= 0) {
                errCount++;

                alert("Vui lòng nhập số điện thoại.")
            }
            else if (txtAddress.length <= 0) {
                errCount++;
              
                alert("Vui lòng nhập địa chỉ.")
            }
            if(errCount > 0) {

                $(".errMsg ul").remove()
                $(".errMsg").append("<ul>" + errMsg + "</ul>");
                $(".errMsg").slideDown('slow');
            }
            return errCount;
        }
        function clear() {
            $("#AddNew").show();
            $("#Update").hide();
        }
    </script>  
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:GridView ID="StudentListGridView" runat="server" AutoGenerateColumns="false">
                <RowStyle BackColor="#ffffff" ForeColor="#000000" Font-Size="16px" />
                <HeaderStyle BackColor="#4a70d0" ForeColor="#ffffff" Font-Size="20px" />
                <AlternatingRowStyle BackColor="#c0c0c0" ForeColor="#000000" Font-Size="16px" />
                <Columns>
                    <asp:BoundField DataField="FullName" HeaderText="Họ và tên" />
                    <asp:BoundField DataField="PhoneNumber" HeaderText="Số điện thoại" />
                    <asp:BoundField DataField="Age" HeaderText="Tuổi" />
                    <asp:BoundField DataField="Address" HeaderText="Địa chỉ" />
                    <asp:TemplateField HeaderStyle-Width="50">
                        <ItemTemplate>
                            <asp:HiddenField ID="hfStudentId" runat="server" Value='<%# Eval("StudentId") %>' />
                            <asp:Button ID="lnkDelete" Text="Xóa" runat="server" />
                            <asp:Button ID="lnkUpdate" Text="Cập nhật" runat="server" />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
        <div>
            <table>
                <tbody>
                    <tr>
                        <td colspan="2">
                            <div class="errMsg"></div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <b>Họ và tên:</b>
                        </td>
                        <td>
                             <asp:TextBox ID="txtFullName" runat="server" ClientIDMode="Static" Width="202px"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                        <td>
                            <b>Số điện thoại:</b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtPhoneNumber" runat="server" ClientIDMode="Static" Width="210px"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                        <td>
                            <b>Tuổi:</b>
                        </td>
                        <td>
                            <asp:TextBox ID="txtAge" TextMode="Number" runat="server" ClientIDMode="Static" Width="210px"></asp:TextBox>
                        </td>
                    </tr>
                     <tr>
                        <td>
                            <b>Địa chỉ:</b>
                        </td>
                        <td>
                             <asp:TextBox ID="txtAddress" runat="server" ClientIDMode="Static" Width="202px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:Button ID="AddNew" runat="server" Text="Thêm"/>
                            <asp:Button ID="Update" runat="server" Text="Cập Nhật"/>
                            <asp:HiddenField ID="hfId" runat="server" />
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </form>
</body>
</html>
