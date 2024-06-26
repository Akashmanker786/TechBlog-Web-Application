/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.techblog.servlets;

import com.techblog.Helper.ConnectionProvider;
import com.techblog.Helper.Helper;
import com.techblog.dao.UserDao;
import com.techblog.entities.Message;
import com.techblog.entities.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.File;

/**
 *
 * @author Akash Manker
 */
@MultipartConfig
public class EditServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet EditServlet</title>");
            out.println("</head>");
            out.println("<body>");

//            fecting all new updated data from form
            String userEmail = request.getParameter("user_email");
            String userName = request.getParameter("user_name");
            String userPassword = request.getParameter("user_password");
            String userAbout = request.getParameter("user_about");
            Part part = request.getPart("user_image");
            String imageName = part.getSubmittedFileName();

            // Now setting the fetched data to currentUser 
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("currentUser");

            user.setName(userName);
            user.setEmail(userEmail);
            user.setPassword(userPassword);
            user.setAbout(userAbout);
            String oldFile = user.getProfile();
            user.setProfile(imageName);

            //creating the object of user dao
            UserDao dao = new UserDao(ConnectionProvider.getConnection());

            // Now sending the updated user date into database 
            boolean flag = dao.updateUser(user);

            if (flag) {
                out.println("data is updated in db");

                String path = request.getServletContext().getRealPath("/") + "pics" + File.separator + user.getProfile();

//               delete code 
                String oldFilePath = request.getServletContext().getRealPath("/") + "pics" + File.separator + oldFile;
                
                if(!oldFile.equals("default.png")){
                Helper.deleteFile(oldFilePath);
                }
                if (Helper.saveFile(part.getInputStream(), path)) {
                    out.println("profile updated");
                    Message msg = new Message("Profile Updated Succesfully", "success", "alert alert-success");
                    session.setAttribute("msg", msg);
                } else {

                    /////
                    Message msg = new Message("Something went wrong", "error", "alert alert-danger");
                    session.setAttribute("msg", msg);

                }

            } else {
                out.println("Not Updated");

                Message msg = new Message("Something went wrong", "error", "alert alert-danger");
                session.setAttribute("msg", msg);
            }

            response.sendRedirect("Profile.jsp");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
