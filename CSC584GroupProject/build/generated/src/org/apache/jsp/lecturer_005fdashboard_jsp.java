package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import com.election.model.UserBean;
import com.election.model.CandidateBean;
import com.election.controller.VoteDAO;
import com.election.controller.UserDAO;
import java.util.List;
import java.util.ArrayList;
import java.util.Collections;

public final class lecturer_005fdashboard_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write(" \n");
      out.write(" \n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");

    /* ===============================
       1. SECURITY CHECK (LECTURER)
       =============================== */
    UserBean currentUser = (UserBean) session.getAttribute("currentUser");
    if (currentUser == null || !currentUser.getRole().equalsIgnoreCase("lecturer")) {
        response.sendRedirect("index.jsp");
        return;
    }

    /* ===============================
       2. INITIALIZE DAOS
       =============================== */
    VoteDAO voteDao = new VoteDAO();
    UserDAO userDao = new UserDAO();

    /* ===============================
       3. FETCH & FILTER DATA
       =============================== */
    String lecturerFaculty = currentUser.getFaculty();
    int totalVotes = voteDao.getTotalVotes();
    List<CandidateBean> approvedList = voteDao.getApprovedCandidates();
    
    // --- FILTER STUDENT DIRECTORY BY FACULTY ---
    List<UserBean> allStudentList = userDao.getNonCandidateStudents();
    List<UserBean> facultyStudentList = new ArrayList<UserBean>();

    if (allStudentList != null) {
        for (UserBean s : allStudentList) {
            if (s.getFaculty() != null && s.getFaculty().equalsIgnoreCase(lecturerFaculty)) {
                facultyStudentList.add(s);
            }
        }
    }

      out.write("\n");
      out.write("\n");
      out.write("<!DOCTYPE html>\n");
      out.write("<html lang=\"en\">\n");
      out.write("<head>\n");
      out.write("    <meta charset=\"UTF-8\">\n");
      out.write("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n");
      out.write("    <title>Lecturer Dashboard - ");
      out.print( lecturerFaculty );
      out.write("</title>\n");
      out.write("    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap\" rel=\"stylesheet\">\n");
      out.write("    <link rel=\"stylesheet\" href=\"css/style.css\">\n");
      out.write("    <style>\n");
      out.write("        .status-badge {\n");
      out.write("            padding: 4px 12px;\n");
      out.write("            border-radius: 20px;\n");
      out.write("            font-size: 0.75rem;\n");
      out.write("            font-weight: 600;\n");
      out.write("            display: inline-block;\n");
      out.write("        }\n");
      out.write("        .voted { background: rgba(46, 204, 113, 0.15); color: #2ecc71; border: 1px solid rgba(46, 204, 113, 0.3); }\n");
      out.write("        .pending { background: rgba(231, 76, 60, 0.15); color: #e74c3c; border: 1px solid rgba(231, 76, 60, 0.3); }\n");
      out.write("    </style>\n");
      out.write("</head>\n");
      out.write("<body>\n");
      out.write("\n");
      out.write("<header>\n");
      out.write("    <div class=\"brand\">Lecturer<span>Dashboard</span></div>\n");
      out.write("    <div class=\"user-pill\">\n");
      out.write("        <span style=\"opacity: 0.7; font-size: 0.8rem; margin-right: 5px;\">");
      out.print( lecturerFaculty );
      out.write(" |</span>\n");
      out.write("        <span>");
      out.print( currentUser.getName() );
      out.write("</span>\n");
      out.write("        <a href=\"LogoutServlet\" class=\"btn-logout\">Logout</a>\n");
      out.write("    </div>\n");
      out.write("</header>\n");
      out.write("\n");
      out.write("<main>\n");
      out.write("    <h2 class=\"section-title\" style=\"margin-top: 0;\">Overview</h2>\n");
      out.write("    <div class=\"stats-grid\">\n");
      out.write("        <div class=\"stat-card\">\n");
      out.write("            <div class=\"stat-number\">");
      out.print( totalVotes );
      out.write("</div>\n");
      out.write("            <div class=\"stat-label\">Total Votes Cast</div>\n");
      out.write("        </div>\n");
      out.write("        <div class=\"stat-card\">\n");
      out.write("            <div class=\"stat-number\">");
      out.print( approvedList.size() );
      out.write("</div>\n");
      out.write("            <div class=\"stat-label\">Active Candidates</div>\n");
      out.write("        </div>\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <h2 class=\"section-title\">Live Results</h2>\n");
      out.write("    <div class=\"candidates-grid\" style=\"margin-bottom: 50px;\">\n");
      out.write("        ");
 for(CandidateBean c : approvedList) { 
      out.write("\n");
      out.write("        <div class=\"candidate-card\">\n");
      out.write("            <div class=\"candidate-image-wrapper\">\n");
      out.write("                <img src=\"");
      out.print( (c.getImagePath() != null && !c.getImagePath().isEmpty()) ? c.getImagePath() : "picture/default.jpg" );
      out.write("\"\n");
      out.write("                     onerror=\"this.onerror=null; this.src='picture/default.jpg';\">\n");
      out.write("            </div>\n");
      out.write("            <div class=\"card-content\">\n");
      out.write("                <span class=\"faculty-badge\">");
      out.print( c.getFaculty() );
      out.write("</span>\n");
      out.write("                <div class=\"candidate-name\">");
      out.print( c.getName() );
      out.write("</div>\n");
      out.write("                <span class=\"total-votes\">");
      out.print( c.getVoteCount() );
      out.write("</span>\n");
      out.write("                <span class=\"vote-label\">Votes</span>\n");
      out.write("            </div>\n");
      out.write("        </div>\n");
      out.write("        ");
 } 
      out.write("\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <h2 class=\"section-title\" style=\"margin-top: 60px;\">Student Directory (");
      out.print( lecturerFaculty );
      out.write(")</h2>\n");
      out.write("    <div class=\"search-wrapper\">\n");
      out.write("        <input type=\"text\" id=\"studentSearchInput\" onkeyup=\"filterStudents()\" placeholder=\"Search ");
      out.print( lecturerFaculty );
      out.write(" students...\">\n");
      out.write("    </div>\n");
      out.write("\n");
      out.write("    <div class=\"table-container\" style=\"max-height: 500px; overflow-y: auto;\">\n");
      out.write("        <table id=\"studentTable\">\n");
      out.write("            <thead>\n");
      out.write("                <tr>\n");
      out.write("                    <th>ID</th>\n");
      out.write("                    <th>Name</th>\n");
      out.write("                    <th>Faculty</th>\n");
      out.write("                    <th>Vote Status</th>\n");
      out.write("                </tr>\n");
      out.write("            </thead>\n");
      out.write("            <tbody>\n");
      out.write("                ");
 if(facultyStudentList.isEmpty()) { 
      out.write("\n");
      out.write("                    <tr><td colspan=\"4\" style=\"text-align: center; padding: 30px;\">No students found for ");
      out.print( lecturerFaculty );
      out.write(".</td></tr>\n");
      out.write("                ");
 } else { 
      out.write("\n");
      out.write("                    ");
 for(UserBean s : facultyStudentList) { 
      out.write("\n");
      out.write("                    <tr>\n");
      out.write("                        <td style=\"color: var(--text-muted);\">");
      out.print( s.getId() );
      out.write("</td>\n");
      out.write("                        <td style=\"font-weight: 500; color: white;\">");
      out.print( s.getName() );
      out.write("</td>\n");
      out.write("                        <td><span class=\"faculty-badge\" style=\"margin:0;\">");
      out.print( s.getFaculty() );
      out.write("</span></td>\n");
      out.write("                        <td>\n");
      out.write("                            ");
 if(s.isVoted()) { 
      out.write("\n");
      out.write("                                <span class=\"status-badge voted\">Voted</span>\n");
      out.write("                            ");
 } else { 
      out.write("\n");
      out.write("                                <span class=\"status-badge pending\">Not Voted</span>\n");
      out.write("                            ");
 } 
      out.write("\n");
      out.write("                        </td>\n");
      out.write("                    </tr>\n");
      out.write("                    ");
 } 
      out.write("\n");
      out.write("                ");
 } 
      out.write("\n");
      out.write("            </tbody>\n");
      out.write("        </table>\n");
      out.write("    </div>\n");
      out.write("</main>\n");
      out.write("\n");
      out.write("<script>\n");
      out.write("    function filterStudents() {\n");
      out.write("        var input = document.getElementById(\"studentSearchInput\");\n");
      out.write("        var filter = input.value.toUpperCase();\n");
      out.write("        var table = document.getElementById(\"studentTable\");\n");
      out.write("        var tr = table.getElementsByTagName(\"tr\");\n");
      out.write("        for (var i = 1; i < tr.length; i++) {\n");
      out.write("            var tdId = tr[i].getElementsByTagName(\"td\")[0]; \n");
      out.write("            var tdName = tr[i].getElementsByTagName(\"td\")[1];\n");
      out.write("            if (tdId || tdName) {\n");
      out.write("                var idValue = tdId.textContent || tdId.innerText;\n");
      out.write("                var nameValue = tdName.textContent || tdName.innerText;\n");
      out.write("                tr[i].style.display = (idValue.toUpperCase().indexOf(filter) > -1 || nameValue.toUpperCase().indexOf(filter) > -1) ? \"\" : \"none\";\n");
      out.write("            }\n");
      out.write("        }\n");
      out.write("    }\n");
      out.write("</script>\n");
      out.write("</body>\n");
      out.write("</html>");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
