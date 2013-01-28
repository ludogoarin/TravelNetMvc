<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.TranslationsFullView>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Traductions
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Traductions</h2>

    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouvelle traduction »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("translation_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouvelle traduction</legend>
            
            <div class="editor-label">
                <label for="Original">Original</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Original", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("Original", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Translated">Traduction</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Translated", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("Translated", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="translations_language_sel">Langue</label>
            </div>
            <div class="editor-field">
                <%
                    var langList = new List<SelectListItem>();
                    foreach (var item in Model.Languages_SelectList)
                    {
                        langList.Add(item);
                    }
                    langList.RemoveAt(0);
                %>
                <%= Html.DropDownList("LanguageId", langList)%>
                <%= Html.ValidationMessage("LanguageId", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
    </div>

    <%= Html.DropDownList("translations_language_sel", Model.Languages_SelectList)%>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                Original
            </th>
            <th>
                Traduction
            </th>
        </tr>

    <% foreach (var item in Model.LanguageTranslations) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "translation_edit", new { id = item.LanguageTranslationId })%> |
                <%= Html.ActionLink("Supprimer", "translation_delete", new { id = item.LanguageTranslationId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Original) %>
            </td>
            <td>
                <%= Html.Encode(item.Translated) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

