<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Products_Tags>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Tags
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Tags</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Tag »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("tags_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Tag</legend>
            
            <div class="editor-label">
                <label for="tag">Tag</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("tag", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("tag", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="tagType">Category</label>
            </div>
            <div class="editor-field">
                <select name="tagType" id="tagType">
                    <option value="sub-activity">Activité spécifique</option>
                    <option value="profile">Profil</option>
                </select>
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
                Tag
            </th>
            <th>
                Catégorie
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Info par langue", "tag_infos", new { id = item.ProductTagId })%> |
                <%= Html.ActionLink("Supprimer", "tag_delete", new { id = item.ProductTagId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <input name="tagName" id="tagName_<%= item.ProductTagId %>" value="<%= item.Tag %>" class="inline-edit" /> 
                <a href="javascript:;" onclick="updateTag(<%= item.ProductTagId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_<%= item.ProductTagId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
            </td>
            <td>
                <%= Html.Encode(item.Type) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

