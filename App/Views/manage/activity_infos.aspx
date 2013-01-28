<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.ActivityInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Activité par Langue
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Activité par Langue</h2>

        <%
            caval_goEntities db = new caval_goEntities();
            
           // make list of select items for RingId's
           List<SelectListItem> ddlLangItems = new List<SelectListItem>();
           List<cg_Languages> colLanguages = db.cg_Languages.OrderBy(l => l.Name).ToList();

           foreach (cg_Languages language in colLanguages)
           {
               if (Model.Where(di => di.Language.LanguageId == language.LanguageId).Count() == 0)
               {
                   SelectListItem item = new SelectListItem();
                   item.Text = language.Name;
                   item.Value = language.LanguageId.ToString();

                   ddlLangItems.Add(item);
               }
           }
        %>
        
    <div class="on-list-new-form">
        <a href="/manage/activities">< Retour</a>
        
        <% if (ddlLangItems.Count() > 0) { %>
         | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("activities_info_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("ActivityId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="activityName">Nom de l'activité</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("activityName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("Name", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="LanguageId">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageId", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageId", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="ShortDescription">Description courte</label> (<a href="javascript:;" onclick="toggleGenericEditor('ShortDescription');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("ShortDescription", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("ShortDescription", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Description">Description</label> (<a href="javascript:;" onclick="toggleGenericEditor('Description');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Description", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Description", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
        <% } %>
    </div>

    <table class="full-width">
        <tr>
            <th></th>
            <th>
                Langue
            </th>
            <th>
                Name
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "activity_info_edit", new { id = item.ActivityInfo.ActivityInfoId })%> |
                <%= Html.ActionLink("Supprimer", "activity_info_delete", new { id = item.ActivityInfo.ActivityInfoId, activityid = ViewContext.RouteData.Values["id"] }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Language.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.ActivityInfo.Name)%>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

