<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cgvw_ProductInfoLanguage>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	products_infos
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
        <%
            caval_goEntities db = new caval_goEntities();
            
           // make list of select items for RingId's
           List<SelectListItem> ddlLangItems = new List<SelectListItem>();
           List<cg_Languages> colLanguages = db.cg_Languages.OrderBy(l => l.Name).ToList();

           foreach (cg_Languages language in colLanguages)
           {
               if (Model.Where(di => di.LanguageId == language.LanguageId).Count() == 0)
               {
                   SelectListItem item = new SelectListItem();
                   item.Text = language.Name;
                   item.Value = language.LanguageId.ToString();

                   ddlLangItems.Add(item);
               }
           }
        %>

    <h2>Info Produit par Langue</h2>
    
    <div class="on-list-new-form">
        <a href="/manage/products">< Retour</a>

        <% if (ddlLangItems.Count() > 0) { %>
         | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Descriptif »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("product_info_add", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>

        <fieldset>
            <legend>Nouveau Descriptif</legend>

            <%= Html.Hidden("ProductId", ViewContext.RouteData.Values["id"])%>
            
            <div class="editor-label">
                <label for="Title">Nom du produit</label>
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
                <label for="Description">Description</label> (<a href="javascript:;" onclick="toggleGenericEditor('Description');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Description", new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Description", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Status">Status</label>
            </div>
            <div class="editor-field">
                <select name="Status" id="Status">
                    <option value="active">active</option>
                    <option value="pending">pending</option>
                </select>
                <%= Html.ValidationMessage("Status", "*")%>
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
                Title
            </th>
            <th>
                Status
            </th>
        </tr>

    <% foreach (var item in Model) {%>
    
        <tr>
            <td>
                <%= Html.ActionLink("Editer", "product_full_edit", new { id = item.ProductId, lid = item.LanguageId })%> |
                <%= Html.ActionLink("Supprimer", "product_info_delete", new { id = item.ProductInfoId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.LanguageName)%>
            </td>
            <td>
                <%= Html.Encode(item.Title) %>
            </td>
            <td>
                <%= Html.Encode(item.Status) %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <br />
    <div>
        <%= Html.ActionLink("< Retour", "products")%>
    </div>

</asp:Content>

