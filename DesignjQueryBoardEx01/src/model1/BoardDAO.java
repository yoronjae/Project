package model1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class BoardDAO {
	private DataSource dataSource;
	
	public BoardDAO() {
		// TODO Auto-generated constructor stub
		try {
			Context initCtx = new InitialContext();
			Context envCtx =(Context)initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource)envCtx.lookup("jdbc/jboard");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			System.out.println("[BoardDAO 에러 ] : "+e.getMessage());
		}
	}
	
	public ArrayList<BoardTO> BoardList(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
		try {
			conn=this.dataSource.getConnection();
			
			String sql="select seq, subject, writer, mail, content from jboard order by seq";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()) {
				BoardTO to = new BoardTO();
				to.setSeq(rs.getString("seq"));
				to.setSubject(rs.getString("subject"));
				to.setWriter(rs.getString("writer"));
				to.setMail(rs.getString("mail"));
				to.setContent(rs.getString("content"));
				
				lists.add(to);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			System.out.println("[boardList 에러] : "+e.getMessage());
		}
		return lists;
	}
	
	public int WriteOk(BoardTO to) {
		Connection conn= null;
		PreparedStatement pstmt=null;
		
		int flag = 1;//비정상
		try {		 
			conn = this.dataSource.getConnection();
			
			String sql="insert into jboard values (0, ?, ?, ?, ?, ?)";
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, to.getSubject() );
	        pstmt.setString(2, to.getWriter());
	        pstmt.setString(3, to.getMail());
	        pstmt.setString(4, to.getPassword());
	        pstmt.setString(5, to.getContent());
	        
	        /*pstmt.setString(1, "제목4" );
	        pstmt.setString(2, "글쓴이4" );
	        pstmt.setString(3, "test4@test.com" );
	        pstmt.setString(4, "123" );
	        pstmt.setString(5, "내용4" );*/
	   
	       	if( pstmt.executeUpdate() == 1){
	        	flag = 0; //data가 정상적으로 insert 되었으면 0
	       	}
		 }catch( SQLException e ) {
	         System.out.println( "[WriteOk 에러] : " + e.getMessage() );
	     }finally {
	         if( pstmt != null ) try { pstmt.close(); } catch( SQLException e ) {}
	         if( conn != null ) try { conn.close(); } catch( SQLException e ) {}
	     }
		return flag;
	}
	
	public BoardTO boardDelete(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();

			String sql = "select subject from jboard where seq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, to.getSeq() );
			
			rs = pstmt.executeQuery();
			if( rs.next() ) {
				to.setSubject( rs.getString( "subject" ) );
			}
		} catch( SQLException e ) {
			System.out.println( "[boardDelete 에러] : " + e.getMessage() );
		} finally {
			if( rs != null ) try { rs.close(); } catch( SQLException e ) {}
			if( pstmt != null ) try { pstmt.close(); } catch( SQLException e ) {}
			if( conn != null ) try { conn.close(); } catch( SQLException e ) {}
		}
		return to;
	}
	
	public int boardDeleteOk(BoardTO to) {
		Connection conn= null;
		PreparedStatement pstmt=null;
		
		int flag = 1;//비정상
		try {		 
			conn = this.dataSource.getConnection();
			
			String sql="delete from jboard where seq=? and password=?";
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, to.getSeq() );
	        pstmt.setString(2, to.getPassword());
	   
	       	if( pstmt.executeUpdate() == 1){
	        	flag = 0; //data가 정상적으로 insert 되었으면 0
	       	}

		 }catch( SQLException e ) {
	         System.out.println( "[boardDeleteOk 에러] : " + e.getMessage() );
	     }finally {
	         if( pstmt != null ) try { pstmt.close(); } catch( SQLException e ) {}
	         if( conn != null ) try { conn.close(); } catch( SQLException e ) {}
	     }
		return flag;
	}
	
	public BoardTO boardModify(BoardTO to) {
		Connection conn= null;
		PreparedStatement pstmt=null;
		ResultSet rs= null; 
		
		try {		 
			conn = this.dataSource.getConnection();
			
			String sql="select subject, writer, mail, password, content from jboard where seq=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
	        
			rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	        	to.setSubject(rs.getString("subject"));
	        	to.setWriter(rs.getString("writer"));
	        	to.setMail(rs.getString("mail"));
	        	to.setPassword(rs.getString("password"));
	        	to.setContent(rs.getString("content"));
	        }
		 }catch( SQLException e ) {
	         System.out.println( "[boardModify 에러] : " + e.getMessage() );
	     }finally {
	         if( rs != null ) try { rs.close(); } catch( SQLException e ) {}
	         if( pstmt != null ) try { pstmt.close(); } catch( SQLException e ) {}
	         if( conn != null ) try { conn.close(); } catch( SQLException e ) {}
	     }
		return to;
	}
	
	public int boardModifyOk(BoardTO to) {
		System.out.println("boardModifyOk");
		Connection conn= null;
		PreparedStatement pstmt=null;
		
		int flag = 1;//비정상
		try {		 
			
			conn = this.dataSource.getConnection();
			
			String sql="update jboard set subject=?, writer=?, mail=?, password=?, content=? where seq=?";
			pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, to.getSubject() );
	        pstmt.setString(2, to.getWriter());
	        pstmt.setString(3, to.getMail());
	        pstmt.setString(4, to.getPassword());
	        pstmt.setString(5, to.getContent());
	        pstmt.setString(6, to.getSeq());
	   
	       	if( pstmt.executeUpdate() == 1){
	        	flag = 0; //data가 정상적으로 insert 되었으면 0
	       	}
	 	
		 }catch( SQLException e ) {
	         System.out.println( "[에러] : " + e.getMessage() );
	     }finally {
	         if( pstmt != null ) try { pstmt.close(); } catch( SQLException e ) {}
	         if( conn != null ) try { conn.close(); } catch( SQLException e ) {}
	     }
		return flag;
	}
}
