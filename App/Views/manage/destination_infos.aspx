<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.DestinationInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	destination_infos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

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

    <h2>Info Destination par Langue</h2>
        
    <div class="on-list-new-form">
        <a href="/manage/destinations">< Retour</a>
        
        <% if (ddlLangItems.Count() > 0) { %>
         | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("destinations_info_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("DestinationId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="Title">Nom de la destination</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Title", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("Title", "*")%>
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
                <label for="MetaDescription">Meta Description</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaDescription")%>
                <%= Html.ValidationMessage("MetaDescription", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="MetaKeywords">Meta Keywords</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaKeywords")%>
                <%= Html.ValidationMessage("MetaKeywords", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="MetaTitle">Meta Title</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaTitle")%>
                <%= Html.ValidationMessage("MetaTitle", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="UrlCustomSegment">Custom URL Segment</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("UrlCustomSegment", null, new { @class = "full-width" })%>
                <%= Html.ValidationMessage("UrlCustomSegment", "*")%>
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
                <%= Html.ActionLink("Edit", "destination_info_edit", new { id = item.DestinationInfo.DestinationInfoId })%> |
                <%= Html.ActionLink("Supprimer", "destination_info_delete", new { id = item.DestinationInfo.DestinationInfoId, destinationid = ViewContext.RouteData.Values["id"] }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Language.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.DestinationInfo.Name)%>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

