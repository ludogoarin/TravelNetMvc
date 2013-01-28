<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.TagInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Info Tags
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

           long currentTagId = Convert.ToInt64(ViewContext.RouteData.Values["id"]);
           cg_Products_Tags currentTag = db.cg_Products_Tags.Where(t => t.ProductTagId == currentTagId).FirstOrDefault();
        %>

    <h2>Info Tags par Langue</h2>

    <p>
        Tag Selectionné: <%= currentTag.Tag %>
    </p>

    <div class="on-list-new-form">
        <a href="/manage/tags">< Retour</a>
        
        <% if (ddlLangItems.Count() > 0) { %>
         | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("tags_info_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("ProductTagId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="tagName">Nom du tag dans la langue</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("tagName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("tagName", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="LanguageId">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageId", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageId", "*")%>
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
                <%= Html.ActionLink("Editer", "tag_info_edit", new { id = item.TagInfo.ProductTagInfoId })%> | 
                <%= Html.ActionLink("Supprimer", "tag_info_delete", new { id = item.TagInfo.ProductTagInfoId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Language.Name) %>
            </td>
            <td>
                <%= item.TagInfo.Name %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

