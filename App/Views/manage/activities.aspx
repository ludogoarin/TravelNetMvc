<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Activities>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Activités
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Activités</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouvelle Activité »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("activities_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle Activité</legend>
            
            <div class="editor-label">
                <label for="activityName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("activityName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("activityName", "*")%>
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
            <th>Id</th>
            <th>
                Nom
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Info par langue", "activity_infos", new { id = item.ActivityId })%> |
                <%= Html.ActionLink("Photos", "site_photos", new { parentId = item.ActivityId, photoType = "activity" })%> |
                <%= Html.ActionLink("Supprimer", "activity_delete", new { id = item.ActivityId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= item.ActivityId %>
            </td>
            <td>
            <% using (Html.BeginForm("destinations_update", "manage", FormMethod.Post))
               { %>
                <input name="activityName" id="activityName_<%= item.ActivityId %>" value="<%= item.Name %>" class="inline-edit" /> 
                <a href="javascript:;" onclick="updateActivity(<%= item.ActivityId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_<%= item.ActivityId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
             <% } %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

