<%@page import="db.DBConnection"%>
<%@page import="sql.*"%>
<%@page import="java.util.*"%>
<%@page import="helper.MyBoolean"%>
<jsp:useBean id="dbaccess" class="db.DBAccess" scope="session" />
<jsp:useBean id="usersession" class="helper.UserSession" scope="session" />
<!doctype html>
<html lang="en">
<head>
<%
    //Start page validation
    String userId = usersession.getUserId();
    if (userId.equals("")) {
        response.sendRedirect("index.jsp?message=Please log in");
        return;
    }
    if(!(usersession.isSuper()||usersession.isDepartmentAdmin())) {
        response.sendRedirect("subjects.jsp?message=You do not have permission to access that page");
    }//End page validation
    
    String message = request.getParameter("message");
    if (message == null || message == "null") {
        message="";
    }
    
    User user = new User(dbaccess);
    String c_id = request.getParameter("c_id");
    String sc_id = request.getParameter("sc_id");
    String toDel = request.getParameter("toDel");
    String bu_id = request.getParameter("bu_id");
    String sc_semesterid = request.getParameter("sc_semesterid");
    if(c_id==null)
        c_id ="";
    if(sc_id==null)
    	sc_id ="";
    if(toDel==null)
        toDel ="";
    if(sc_semesterid==null)
    	sc_semesterid ="";
    if(bu_id==null)
    	bu_id ="";
    
    Section section=new Section(dbaccess);
    ArrayList<ArrayList<String>> allSection = new  ArrayList<ArrayList<String>>();
    section.getSectionInfo(allSection);
%>
	<meta http-equiv="Content-Type" content="text/html" charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Create Professor</title>
	<link rel="icon" href="http://www.cssreset.com/favicon.png">
	<link rel="stylesheet" type="text/css" media="all" href="css/fonts.css">
	<link rel="stylesheet" type="text/css" media="all" href="css/themes/base/style.css">
	<script type="text/javascript" src="http://code.jquery.com/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="js/modernizr.custom.79639.js"></script>
	<script type="text/javascript" src="js/componentController.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/jquery.validate.min.js"></script>
    <script type="text/javascript" src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.11.1/additional-methods.min.js"></script>
</head>

<body>
<div id="page">
    <jsp:include page="header.jsp"/>
    <jsp:include page="menu.jsp"/>
    <section>
        <header> 
            <!-- BREADCRUMB -->
            <p><a href="calendar.jsp" tabindex="13">home</a>� <a href="subjects.jsp" tabindex="14">subjects</a> � <a href="manage_professor.jsp" tabindex="14">manage professor</a> �<a href="create_professor.jsp" tabindex="15">create Professor</a></p>
            <!-- PAGE NAME -->           
            <h1>Create Professor</h1>            
            <!-- WARNING MESSAGES -->
            <div class="warningMessage"><%= message %></div>
        </header>
               <form name="createProfessor" id="createProfessor" method="post" action="persist_professor.jsp">
            <article>
                <header>
                    <h2>Professor Form</h2>
                    <img class="expandContent" width="9" height="6" src="images/arrowDown.svg" title="Click here to collapse/expand content"/>
                </header>
                <div class="content">
                    <fieldset>
                        <div class="component">
                            <label for="professorid" class="label">Professor ID:</label>
                            <input type="text" name="professorid" id="professorid" class="input" tabindex="2" title="Please Enter Professor id" >                         
                        </div>
                        <div class="component">
                            <label for="sectionList" class="label">Section List:</label>
                            <select name="sectionList" id="sectionList" title="Please Select a section">
                            <% for(int i=0;i<allSection.size();i++){ %>
                                <option><%= allSection.get(i).get(0).concat(" ").concat(allSection.get(i).get(1)).concat(" ").concat(allSection.get(i).get(2)).concat(" ").concat(allSection.get(i).get(3)) %>  </option><%} %>
                            </select>
                        </div>
                        <div class="component">
                            <div class="buttons">                        
                               <button type="submit" name="createProfessor" id="createProfessor" class="button" title="Click here to create">Create</button>                                                                                       
                               <button type="reset" name="resetCourse" id="resetCourse" class="button" title="Click here to reset">Reset</button>
                               <button type="button" name="button" id="cancelCourse"  class="button" title="Click here to cancel" 
                                onclick="window.location.href='manage_professor.jsp'">Cancel</button>
                            </div>
                        </div>
                    </fieldset>
                </div>
            </article>
        </form> 
    </section>
       <script>    
   // form validation, edit the regular expression pattern and error messages to meet your needs
       $(document).ready(function(){
            $('#createProfessor').validate({
                validateOnBlur : true,
                rules: {
                	professorid: {
                       required: true,
                       pattern: /^\s*[a-zA-z]+[ \. a-zA-z]*\s*$/
                   }              
                },
                messages: {
                	professorid: { 
                        pattern:"Please enter a valid professor id",
                        required:"Professor id is required"
                    }
                }
            });
        });
  </script>
    <jsp:include page="footer.jsp"/>
</div>
</body>
</html>

