<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.CmsStaticBlockInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Blocks de contenu par langue
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

    <h2>Blocks de contenu par langue</h2>
        
    <div class="on-list-new-form">
        <a href="/manage/cms_staticblocks">< Retour</a>
        
        <% if (ddlLangItems.Count() > 0) { %>
        | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("cms_staticblock_info_add", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("BlockId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="LanguageId">Langue</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("LanguageId", ddlLangItems)%>
                <%= Html.ValidationMessage("LanguageId", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Code">Code HTML</label> (<a href="javascript:;" onclick="toggleGenericEditor('Code');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Code", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Code", "*")%>
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
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "cms_staticblock_info_edit", new { id = item.BlockInfo.StaticBlockInfoId })%> |
                <%= Html.ActionLink("Supprimer", "cms_staticblock_info_delete", new { id = item.BlockInfo.StaticBlockInfoId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Language.Name) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

