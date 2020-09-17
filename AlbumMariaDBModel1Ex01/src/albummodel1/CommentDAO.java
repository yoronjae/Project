package albummodel1;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class CommentDAO {
	private DataSource dataSource = null;
	
	public CommentDAO() {
		// TODO Auto-generated constructor stub
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup( "java:comp/env" );
			this.dataSource = (DataSource)envCtx.lookup( "jdbc/ubuntu" );
		} catch( NamingException e ) {
			// TODO Auto-generated catch block
			System.out.println("[에러] : " + e.getMessage());
		}
	}
	
	public ArrayList<CommentTO> commentList(CommentTO cto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		ArrayList<CommentTO> commentLists = new ArrayList<>();
		try {
			conn = dataSource.getConnection();
			
			String sql = "select seq, writer, content, wdate from album_comment1 where pseq=? order by seq";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, cto.getPseq() );
			
			rs = pstmt.executeQuery();

			while( rs.next() ) {
				CommentTO to = new CommentTO();
				to.setSeq( rs.getString("seq" ) );
				to.setWriter( rs.getString( "writer" ) );
				to.setContent( rs.getString( "content" ) );
				to.setWdate( rs.getString("wdate"));
				commentLists.add( to );
			}
			
		} catch( SQLException e ) {
			System.out.println( "[에러] : " + e.getMessage() );
		} finally {
			if( rs != null) try { rs.close(); } catch( SQLException e ) {}
			if( pstmt != null) try { pstmt.close(); } catch( SQLException e ) {}
			if( conn != null) try { conn.close(); } catch( SQLException e ) {}
		}
		return commentLists;
	}
	
	public int commentWriteOk(CommentTO cto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		int flag = 1;
		try {
			conn = dataSource.getConnection();
			
			String sql = "insert into album_comment1 values (0, ?, ?, ?, ?, now())";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, cto.getPseq() );
			pstmt.setString( 2, cto.getWriter() );
			pstmt.setString( 3, cto.getPassword() );
			pstmt.setString( 4, cto.getContent() );
			
			int result = pstmt.executeUpdate();
			if( result == 1 ) {
				sql = "update album_board1 set cmt=cmt+1 where seq=?";
				pstmt = conn.prepareStatement( sql );
				pstmt.setString( 1, cto.getPseq() );
				
				pstmt.executeUpdate();

				flag = 0;
			}		
		} catch( SQLException e ) {
			System.out.println( "[에러] : " + e.getMessage() );
		} finally {
			if( pstmt != null) try { pstmt.close(); } catch( SQLException e ) {}
			if( conn != null) try { conn.close(); } catch( SQLException e ) {}
		}
		return flag;
	}
	
	public int commentDeleteOk(BoardTO bto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int flag = 2;
		
		try {
			conn = dataSource.getConnection();
			
			String sql = "delete from album_comment1 where pseq=?";
			pstmt = conn.prepareStatement( sql );
			pstmt.setString( 1, bto.getSeq() );
					
			int result = pstmt.executeUpdate();
			if( result == 0 ) {
				flag = 1;
			} else if( result == 1 ) {
				flag = 0;
			}
		} catch( SQLException e ) {
			System.out.println("[에러] : " + e.getMessage() );
		} finally {
			if( rs != null) try { rs.close(); } catch( SQLException e ) {}
			if( pstmt != null) try { pstmt.close(); } catch( SQLException e ) {}
			if( conn != null) try { conn.close(); } catch( SQLException e ) {}
		}
		return flag;
	}
}
