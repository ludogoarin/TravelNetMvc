<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Languages>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	langues
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Langues</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouvelle Langue »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("language_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle Langue</legend>
            
            <div class="editor-label">
                <label for="productName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("languageName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("languageName", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="systemLocale">SystemLocale</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("systemLocale")%>
                <%= Html.ValidationMessage("systemLocale", "*")%>
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
                Language Id
            </th>
            <th>
                Nom
            </th>
            <th>
                System Locale
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "language_edit", new { id = item.LanguageId })%> |
                <%= Html.ActionLink("Supprimer", "language_delete", new { id = item.LanguageId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.LanguageId) %>
            </td>
            <td>
                <%= Html.Encode(item.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.SystemLocale) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

