<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_cms_Pages>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	cms_pages
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Pages de Contenu</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouvelle Page »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("cms_page_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle Page</legend>
            
            <div class="editor-label">
                <label for="pageName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("pageName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("pageName", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
    </div>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                Nom de page
            </th>
            <th>
                Lien vers la page CMS
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Info par langue", "cms_page_infos", new { id=item.PageId })%> |
                <%= Html.ActionLink("Supprimer", "cms_page_delete", new { id = item.PageId }, new { @class = "delete_action" })%>
            </td>
            <td>
            <% using (Html.BeginForm("destinations_update", "manage", FormMethod.Post))
               { %>
                <input name="pageName" id="pageName_<%= item.PageId %>" value="<%= item.Name %>" class="inline-edit" /> 
                <a href="javascript:;" onclick="updateCmsPage(<%= item.PageId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_<%= item.PageId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
             <% } %>
            </td>
            <td>
                <a href="/cms/<%= Server.UrlEncode(item.Name.ToLower()) %>" target="_blank">/cms/<%= item.Name.ToLower() %></a> 
                <a href="/cms/<%= Server.UrlEncode(item.Name.ToLower()) %>" target="_blank"><img src="../../Content/images/admin/icons/bullet_go.png" align="absmiddle" /></a>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

