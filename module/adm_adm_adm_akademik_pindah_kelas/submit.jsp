<%--
 % Copyright 2011 - Kementerian Pendidikan Nasional - Dit.PSMP
 %
 % Author(s):
 % + x10c-Lab
 %   - agus sugianto (agus.delonge@gmail.com)
--%>

<%@ page import = "java.sql.*" %>
<%@ page import	= "java.util.Properties" %>
<%@ page import	= "java.io.FileInputStream" %>
<%@ page import	= "java.io.File" %>
<%
try{
	Connection	db_con	= (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt = db_con.createStatement();

	int dml 				= Integer.parseInt(request.getParameter("dml_type"));
	String kd_tahun_ajaran	= request.getParameter("kd_tahun_ajaran");
	String kd_tingkat_kelas	= request.getParameter("kd_tingkat_kelas");
	String kd_rombel		= request.getParameter("kd_rombel");
	String id_siswa			= request.getParameter("id_siswa");
	String username			= (String) session.getAttribute("user.id");
	String q				= "";

	switch (dml) {
	case 3:
		q	=" update	t_siswa_tingkat"
			+" set		kd_rombel	= '"+ kd_rombel +"'"
			+" ,		username	= '"+ username +"'"
			+" where	kd_tahun_ajaran		= '"+ kd_tahun_ajaran + "'"
			+" and		kd_tingkat_kelas	= '"+ kd_tingkat_kelas + "'"
			+" and		id_siswa			=  "+ id_siswa;
		break;
	default:
		out.print("{success:false,info:'DML tipe tidak diketahui ("+dml+")!'}");
		return;
	}

	db_stmt.executeUpdate(q);
	
	out.print("{success:true,info:'Data telah tersimpan.'}");
} catch (Exception e){
	Properties	props	= new Properties();
	
	props.load(new FileInputStream(application.getRealPath("WEB-INF"+File.separator+"error.properties")));

	String		err_msg	= props.getProperty("" + e.getErrorCode() + "");
	
	if (err_msg == null){
		out.print("{success:false,info:'" + e.getErrorCode() + " = Kesalahan operasi, silahkan hubungi direktorat.'}");
	} else {
		out.print("{success:false,info:'" + e.getErrorCode() + " = " + err_msg + "'}");
	}
}
%>
