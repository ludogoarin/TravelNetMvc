<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_cms_StaticBlocks>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Blocks de Contenu Statique
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Blocks de Contenu Statique</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Block »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("cms_staticblock_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Block</legend>
            
            <div class="editor-label">
                <label for="blockName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("blockName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("blockName", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
    </div>

    <div class="warning">NOTE: Ne pas changer le nom des blocks.</div>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                Nom du block
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Info par langue", "cms_staticblock_infos", new { id=item.StaticBlockId })%> |
                <%= Html.ActionLink("Supprimer", "cms_staticblock_delete", new { id = item.StaticBlockId }, new { @class = "delete_action" })%>
            </td>
            <td>
            <% using (Html.BeginForm("destinations_update", "manage", FormMethod.Post))
               { %>
                <input name="blockName" id="blockName_<%= item.StaticBlockId %>" value="<%= item.Name %>" class="inline-edit" /> 
                <a href="javascript:;" onclick="updateCmsBlock(<%= item.StaticBlockId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_<%= item.StaticBlockId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
             <% } %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

