<%--
 % Copyright 2011 - Kementerian Pendidikan Nasional - Dit.PSMP
 %
 % Author(s):
 % + x10c-Lab
 %   - agus sugianto (agus.delonge@gmail.com)
--%>

<%@ page import="java.sql.*" %>
<%
try{
	Connection	db_con	= (Connection) session.getAttribute("db.con");
	if (db_con == null || (db_con != null && db_con.isClosed())) {
		response.sendRedirect(request.getContextPath());
		return;
	}

	Statement	db_stmt = db_con.createStatement();

	String kd_tahun_ajaran		= (String) session.getAttribute("kd.tahun_pelajaran");
	String start				= request.getParameter("start");
	String limit				= request.getParameter("limit");
	
	String q=" select	a.id_pegawai"
			+" ,		a.nip"
			+" ,		a.nuptk"
			+" ,		a.nm_pegawai"
			+" from		t_pegawai		as a"
			+" ,		t_pegawai_aktif	as b"
			+" where	a.id_pegawai			= b.id_pegawai"
			+" and		a.kd_jenis_ketenagaan	= '2'"
			+" and		b.status_aktif			= '1'"
			+" and		b.kd_tahun_ajaran	= '" + kd_tahun_ajaran + "'"
			+" order by a.kd_jenis_ketenagaan, a.nm_pegawai";
	
	ResultSet	rs	= db_stmt.executeQuery(q);
	int		i	= 0;
	String		data	= "[";

	while (rs.next()){
		if (i > 0) {
			data += ",";
		} else {
			i++;
		}
		data 	+="["+ rs.getString("id_pegawai")
				+ ",'"+ rs.getString("nip") + "'"
				+ ",'"+ rs.getString("nuptk") + "'"
				+ ",\""+ rs.getString("nm_pegawai") +"\""
				+ "]";
	}	
	data += "]";
	
	out.print(data);
}catch (Exception e){
	out.print("{success:false,info:'"+ e.toString().replace("'","\\'") +"'}");
}
%>
