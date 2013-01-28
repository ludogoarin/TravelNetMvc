<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    if (Request.IsAuthenticated) {
%>
        Welcome <b><%= Html.Encode(Page.User.Identity.Name) %></b>!
        [ <%= Html.ActionLink("Dé-connexion", "logoff", "logon")%> ]
<%
    }
    else {
%> 
        [ <%= Html.ActionLink("Connexion", "index", "logon") %> ]
<%
    }
%>
