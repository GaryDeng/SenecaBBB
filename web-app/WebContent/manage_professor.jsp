<%@page import="db.DBConnection"%>
<%@page import="sql.User"%>
<%@page import="sql.Section"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Seneca | Professors</title>
<link rel="icon" href="http://www.cssreset.com/favicon.png">
<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.core.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.theme.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.datepicker.css">
<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/jquery.ui.selectmenu.css">
<link rel='stylesheet' type="text/css" href='fullcalendar-1.6.3/fullcalendar/fullcalendar.css'>
<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script type="text/javascript" src='fullcalendar-1.6.3/fullcalendar/fullcalendar.js'></script>
<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.core.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.widget.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.position.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.selectmenu.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.stepper.js"></script>
<script type="text/javascript" src="js/ui/jquery.ui.dataTable.js"></script>
<script type="text/javascript" src="js/componentController.js"></script>
<script type="text/javascript">
//Table
$(screen).ready(function() {

    /* Course List */
    $('#professorList').dataTable({
        "bPaginate": true,
        "bLengthChange": true,
        "bFilter": true,
        "bSort": true,
        "bInfo": true,
        "bAutoWidth": false});
    $('#professorList').dataTable({"aoColumnDefs": [{ "bSortable": true, "aTargets":[5]}], "bRetrieve": true, "bDestroy": true});
    $.fn.dataTableExt.sErrMode = 'throw';
    $('.dataTables_filter input').attr("placeholder", "Filter entries");       
    $('#professorList').dataTable({"sPaginationType": "full_numbers"});
    

});
</script>
<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?error=Please log in");
        return;
    }
    if (!(usersession.isDepartmentAdmin() || usersession.isSuper())) {
        response.sendRedirect("calendar.jsp");
        return;
    }
    if (dbaccess.getFlagStatus() == false) {
        response.sendRedirect("index.jsp?error=Database connection error");
        return;
    } //End page validation


    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    
    User user = new User(dbaccess);
    Section section = new Section(dbaccess);
    ArrayList<ArrayList<String>> allProfessors = new ArrayList<ArrayList<String>>();
    MyBoolean prof = new MyBoolean();
    HashMap<String, Integer> userSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> meetingSettings = new HashMap<String, Integer>();
    HashMap<String, Integer> roleMask = new HashMap<String, Integer>();
    userSettings = usersession.getUserSettingsMask();
    meetingSettings = usersession.getUserMeetingSettingsMask();
    roleMask = usersession.getRoleMask();
    int nickName = roleMask.get("nickname");
    
    section.getProfessor(allProfessors);
    
%>


</head>
<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a> � <a href="subjects.jsp" tabindex="14">subjects</a>� <a href="manage_professor.jsp" tabindex="14">manage professor</a></p>
            <!-- PAGE NAME -->
            <h1>Professors List</h1>
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%=message %></div>
        </header>
        <form>
           <article>
                <header>
                    <h2>Professors</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">                                 
                <fieldset>
                <% if (usersession.isSuper() || usersession.isDepartmentAdmin()) { %>
                  <div class="tableComponent">
                      <table id="professorList" border="0" cellpadding="0" cellspacing="0">
                        <thead>
                          <tr>
                            <th width="100" class="firstColumn" tabindex="16" title="courseid">Professor ID<span></span></th>
                            <th  width="200" title="coursename">Course ID<span></span></th>
                            <th  width="200" title="sectionID">Section ID<span></span></th>
                            <th  width="200" title="semesterID">Semester ID<span></span></th>                          
                            <th  width="65" title="Remove" class="icons" align="center">Remove</th>
                          </tr>
                        </thead>
                        <tbody>
                        <% for(int j=0; j<allProfessors.size();j++){%>
                          <tr>
                            <td class="row"><%= allProfessors.get(j).get(0) %></td>
                            <td ><%= allProfessors.get(j).get(1) %></td>   
                            <td ><%= allProfessors.get(j).get(2) %></td>  
                            <td ><%= allProfessors.get(j).get(3) %></td>                     
                            <td  align="center"><a href="persist_professor.jsp?bu_id=<%= allProfessors.get(j).get(0) %>&c_id=<%= allProfessors.get(j).get(1) %>&sc_id=<%= allProfessors.get(j).get(2) %>&sc_semesterid=<%= allProfessors.get(j).get(3) %>&toDel=1" class="remove"><img src="images/iconPlaceholder.svg" width="17" height="17" title="Remove course" alt="Remove"/></a></td>
                          </tr><% } %>
                        </tbody>
                      </table>
                    </div>
                <% } %>
                </fieldset>
                </div>
            </article>
                     <div class="actionButtons">
                        <button type="button" name="button" id="addProfessor" class="button" title="Click here to add a professor" onclick="window.location.href='create_professor.jsp'">Add Professor</button>
                    </div>

        </form>
    </section>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>