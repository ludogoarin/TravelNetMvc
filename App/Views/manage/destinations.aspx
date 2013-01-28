<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Destinations>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	destinations
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Destinations</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouvelle Destination »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("destinations_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle Destination</legend>
            
            <div class="editor-label">
                <label for="destinationName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("destinationName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("destinationName", "*")%>
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
                Name
            </th>
            <th>
                Map Address
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Info par langue", "destination_infos", new { id=item.DestinationId })%> |
                <%= Html.ActionLink("Photos", "site_photos", new { parentId = item.DestinationId, photoType = "destination" })%> |
                <%= Html.ActionLink("Supprimer", "destination_delete", new { id = item.DestinationId }, new { @class = "delete_action" })%>
            </td>
            <td>
            <% using (Html.BeginForm("destinations_update", "manage", FormMethod.Post))
               { %>
                <input name="destinationName" id="destinationName_<%= item.DestinationId %>" value="<%= item.Name %>" class="inline-edit" /> 
                <a href="javascript:;" onclick="updateDestination(<%= item.DestinationId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_<%= item.DestinationId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
             <% } %>
           </td>
            <td>
            <% using (Html.BeginForm("destinations_update_address", "manage", FormMethod.Post))
               { %>
                <input name="destinationAddress" id="destination_Address_<%= item.DestinationId %>" value="<%= item.MapAddress %>" class="inline-edit" />
                <a href="javascript:;" onclick="updateDestinationAddress(<%= item.DestinationId %>);" title="Sauvegarder" class="inline-edit-save-button" id="inlineSaveBt_Address_<%= item.DestinationId %>"><img src="../../Content/images/admin/icons/bullet_disk.png" /></a>
             <% } %>
           </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

