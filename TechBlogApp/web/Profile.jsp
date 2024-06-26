<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page  errorPage="Error_page.jsp" %>
<%@page  import="com.techblog.entities.User , com.techblog.entities.Message" %>
<%@page  import="com.techblog.entities.* , java.util.* , com.techblog.Helper.* ,com.techblog.dao.*" %>

<%
    User user = (User) session.getAttribute("currentUser");
     if(user==null){
     response.sendRedirect("Login_page.jsp");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Profile page</title>

        <link href="CSS/MyCSS.css" rel="stylesheet" type="text/css"/>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">

        <style>
            body{
                background:  url(images/img3.jpeg);
                background-size: cover;
                background-attachment: fixed;
            }

            .banner-background{
                clip-path: polygon(50% 0, 100% 0, 100% 45%, 100% 88%, 78% 90%, 54% 99%, 22% 91%, 0 100%, 0 47%, 0 0);
            }
        </style>

    </head>
    <body>

        <!--navbar starting--> 

        <nav class="navbar navbar-expand-lg navbar-dark primary-background">
            <a class="navbar-brand" href="#">  <span class="fa fa-snowflake-o"></span> TechBlog</a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item active">
                        <a class="nav-link active" href="index.jsp"> <span class="fa fa-home"></span> Home <span class="sr-only">(current)</span></a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link active" href="AboutPage.jsp"> <span class="fa fa-group"></span>About-Us</a>
                    </li>
                    <li class="nav-item active  dropdown">

                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                            <span class="fa fa-info-circle"></span> Categories
                        </a>
                        <div class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="#">Programming Language</a>
                            <a class="dropdown-item" href="#">Project Implementation</a>
                            <div class="dropdown-divider"></div>
                            <a class="dropdown-item" href="#">Data Structure</a>
                        </div>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="#"> <span class="fa fa-bell"></span> Notifications</a>
                    </li>

                    <li class="nav-item active">
                        <a class="nav-link" href="Login_page.jsp" data-toggle="modal" data-target="#create-post-modal"> <span class="fa fa-plus-square"></span> Create Post</a>
                    </li>

                </ul>

                <ul class ="navbar-nav mr-right">
                    <li class="nav-item active">
                        <a class="nav-link" href="Profile.jsp" data-toggle="modal" data-target="#profile-modal"> <span class="fa fa-user-circle"></span> <%=user.getName()%></a>

                    <li class="nav-item active">
                        <a class="nav-link" href="LogoutServlet"> <span class="fa fa-sign-in"></span> Logout</a>
                    </li>

                </ul>

            </div>
        </nav>
        <!--navbar ends-->


        <% 
                                Message m = (Message) session.getAttribute("msg");      
                            
                                if(m != null){
                                
        %>

        <div class="alert <%= m.getCssClass() %>" role="alert">
            <%= m.getContent() %>
        </div>

        <%
              session.removeAttribute("msg");
            }
        %>


        <!--main body starts -->
        <main>
            <div class="container">
                <div class="row mt-4">

                    <!--first column-->
                    <div class="col-md-4">
                        <div class="list-group">
                            <a href="#" onclick="showPosts(0, this)" class=" show-activate list-group-item list-group-item-action  active">
                                All Posts
                            </a>
                            <% 
                               PostDao  pd = new PostDao(ConnectionProvider.getConnection());
                               ArrayList<Categories> list2 =  pd.getAllCategories();
                               for(Categories cc : list2){
                            %>
                            <a href="#" onclick="showPosts(<%= cc.getcId()%>, this)" class="show-activate list-group-item list-group-item-action disabled  "><%= cc.getcName()%></a>
                            <%
                                }
                            %>
                        </div>
                    </div>

                    <!--second columnn-->
                    <div class="col-md-8">
                        <!--posts-->
                        <div  id="loader" class="container text-center">
                            <i class="fa fa-refresh fa-4x fa-spin" > </i>
                            <h3 class="mt-3">Loading...</h3>
                        </div>

                        <div id="post-container" class="container-fluid text-center">

                        </div>

                    </div>

                </div>
            </div>
        </main>

        <footer class = footer-section>


        </footer>


        <!--main body ends-->




        <!--profile model starts-->

        <!-- Modal -->
        <div class="modal fade" id="profile-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background text-white">
                        <h5 class="modal-title" id="exampleModalLabel">TechBlog</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="container text-center">
                            <img class = "img-fluid" src="pics/<%= user.getProfile()%>"  style="border-radius: 50%; max-width: 150px"/>
                            <h4 class="modal-title mt-2"><%= user.getName()%></h4>


                            <!--user details table;-->
                            <div id="profile-details">
                                <table class="table">

                                    <tbody>
                                        <tr>
                                            <th scope="row">User-id :</th>
                                            <td><%= user.getId()%></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Email :</th>
                                            <td><%= user.getEmail()%></td>
                                        </tr>
                                        <tr>
                                            <th scope="row">Gender :</th>
                                            <td><%= user.getGender()%></td>
                                        </tr>

                                        <tr>
                                            <th scope="row">About :</th>
                                            <td><%= user.getAbout()%></td>
                                        </tr>

                                        <tr>
                                            <th scope="row">Registered on :</th>
                                            <td><%=  user.getDateTime().toString()%></td>
                                        </tr>

                                    </tbody>
                                </table>

                            </div>


                            <!--profile-edit-->

                            <div id="profile-edit" style="display: none">
                                <h5 class="mt-2 mb-2">Please edit carefully</h5>

                                <form action="EditServlet" method="POST" enctype="multipart/form-data">
                                    <table class="table">
                                        <tr>
                                            <td>ID :</td>
                                            <td><%= user.getId() %></td>
                                        </tr>

                                        <tr>
                                            <td>Name :</td>
                                            <td><input type="text" class="form-control" name="user_name" value="<%= user.getName()%>"  /></td>
                                        </tr>

                                        <tr>
                                            <td>Email :</td>
                                            <td><input type="email" class="form-control" name="user_email" value="<%= user.getEmail()%>"  /></td>
                                        </tr>

                                        <tr>
                                            <td>Password :</td>
                                            <td><input type="password" class="form-control" name="user_password" value="<%= user.getPassword()%>"  /></td>
                                        </tr>

                                        <tr>
                                            <td>Gender :</td>
                                            <td><%= user.getGender() %></td>
                                        </tr>

                                        <tr>
                                            <td>About :</td>
                                            <td>
                                                <textarea class="form-control" name="user_about"><%= user.getAbout() %>
                                                </textarea>
                                            </td>
                                        </tr>

                                        <tr>
                                            <td>New Profile Picture:</td>
                                            <td>
                                                <input type="file" name="user_image" class="form-control" />   
                                            </td>
                                        </tr>

                                    </table>

                                    <div class="container">
                                        <button type="submit" class="btn btn-outline-primary">Save</button>
                                    </div>

                                </form>
                            </div>

                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                        <button id="profile-edit-button" type="button" class="btn btn-primary">Edit Profile</button>
                    </div>
                </div>
            </div>
        </div>
        <!--profile modal ends-->




        <!--create-post modal starts-->


        <!-- Modal -->
        <div class="modal fade" id="create-post-modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header primary-background">

                        <h5 class="modal-title" id="exampleModalLabel">Create New Post</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="container">
                            <img class = "img-fluid" src="pics/<%= user.getProfile()%>"  style="border-radius: 100%; width: 75px; height: 75px"/>
                            <h4 class="modal-title mt-2"><%= user.getName()%></h4>

                            <form id="add-post-form" action="AddPostServlet" method="POST">

                                <div class="form-group">
                                    <select  name="cId" class="form-control">
                                        <option selected disabled>--Select Category--</option>
                                        <% 
                                           PostDao dao = new PostDao(ConnectionProvider.getConnection());
                                         ArrayList<Categories> list =   dao.getAllCategories();
                                           
                                          for(Categories c : list){
                                        %>
                                        <option value="<%= c.getcId() %>"><%= c.getcName() %></option>

                                        <% 
                                            }
                                          
                                        %>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <input name="pTitle" type="text" placeholder="Add Post Title" class="form-control"/>
                                </div>

                                <div class="form-group">
                                    <textarea name="pContent" rows="6" cols="4" id="id"  placeholder="What do you want to talk about ?" class="form-control" style="height: 200px"></textarea>
                                </div>


                                <div class="form-group">
                                    <label>Select Picture</label>            
                                    <input name="pImage" type="file" class= " form-control" id="customFile">
                                </div>

                                <div class="container text-center">
                                    <button type="submit" class="btn btn-outline-primary mt-3" >Post</button>
                                </div>

                            </form>
                        </div>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>
        </div>

        <!--create-post modal ends-->






        <!--        javaSrcipt -->

        <script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha256-kmHvs0B+OpCW5GVHUNjv9rOmY0IvSIRcf7zGUDTDQM8=" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/popper.js@1.12.9/dist/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.0.0/dist/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
        <script src="JavaScript/MyJavaSrcipt.js" type="text/javascript"></script>

        <script src="https://code.jquery.com/jquery-3.7.1.js"  integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4="
        crossorigin="anonymous"></script>

        <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>


        <script>

                                $(document).ready(function () {

                                    let editStatus = false;

                                    $("#profile-edit-button").click(function () {

                                        if (editStatus == false)
                                        {
                                            $("#profile-edit").show()

                                            $("#profile-details").hide();
                                            editStatus = true;

                                            $(this).text("Back");
                                        } else {
                                            $("#profile-edit").hide();

                                            $("#profile-details").show();
                                            editStatus = false;

                                            $(this).text("Edit Profile");
                                        }

                                    });
                                });

        </script>


        <!--// jquery for add post modal-->
        <script>

            $(document).ready(function () {

                $("#add-post-form").on("submit", function (event) {
//                     code runs after form submitedd
                    event.preventDefault();

                    console.log("submit button clicked ");

                    let form = new FormData(this);

//                        now submitting form to servlet
                    $.ajax({

                        url: "AddPostServlet",
                        type: "POST",
                        data: form,

                        success: function (data, textStatus, jqXHR) {
                            //success
                            console.log(data);
                            if (data.trim() == "done") {
                                swal("Good job!", "Posted Successfully!", "success");
                            } else {
                                swal("Error!", "Something Went Wrong!", "error");

                            }
                        },
                        error: function (jqXHR, textStatus, errorThrown) {
//                        error
                            swal("Error!", "Something Went Wrong!", "error");

                        },

                        processData: false,
                        contentType: false
                    });

                });

            });

        </script>


        <script>

            function showPosts(catId, temp) {

                $(".show-activate").removeClass("active");

                $.ajax({
                    // passing category id to server
                    data: {cid: catId},

                    url: "Load_Posts.jsp",
                    success: function (data, textStatus, jqXHR) {

                        $("#loader").hide();
                        $("#post-container").html(data);
                        $(temp).addClass("active");
                    }


                });
            }

            $(document).ready(function (e) {

                let allPostRef = $('.show-activate')[0];
                showPosts(0, allPostRef);

            });
        </script>


    </body>
</html>
