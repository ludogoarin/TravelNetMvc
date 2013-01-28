<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Products>>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	products
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
    <%
        caval_goEntities db = new caval_goEntities();

        // make list of select items for destinations
        List<SelectListItem> destItems = new List<SelectListItem>();
        List<cg_Destinations> colDestinations = db.cg_Destinations.OrderBy(d => d.Name).ToList();

        foreach (cg_Destinations destination in colDestinations)
        {
            SelectListItem item = new SelectListItem();
            item.Text = destination.Name;
            item.Value = destination.DestinationId.ToString();

            destItems.Add(item);
        }

        // make list of select items for activities
        List<SelectListItem> activityItems = new List<SelectListItem>();
        List<cg_Activities> colActivities = db.cg_Activities.OrderBy(a => a.Name).ToList();

        foreach (cg_Activities activity in colActivities)
        {
            SelectListItem item = new SelectListItem();
            item.Text = activity.Name;
            item.Value = activity.ActivityId.ToString();

            activityItems.Add(item);
        }

        // make list of select items for tags
        List<SelectListItem> tagItems = new List<SelectListItem>();
        List<cg_Products_Tags> colTags = db.cg_Products_Tags.OrderBy(t => t.Tag).ToList();
        List<SelectListItem> destItemsFilter = new List<SelectListItem>();
        string tagFilter = Request.QueryString["tag"];
        string destFilter = Request.QueryString["destination"];
        string nameFilter = Request.QueryString["src_productName"];
        string codeFilter = Request.QueryString["src_productCode"];

        SelectListItem viewAllDestinations = new SelectListItem();
        viewAllDestinations.Text = "- toutes -";
        viewAllDestinations.Value = "";
        viewAllDestinations.Selected = destFilter == "" ? true : false;
        destItemsFilter.Add(viewAllDestinations);

        foreach (cg_Destinations destination in colDestinations)
        {
            SelectListItem item = new SelectListItem();
            item.Text = destination.Name;
            item.Value = destination.DestinationId.ToString();
            item.Selected = destFilter == item.Value ? true : false;

            destItemsFilter.Add(item);
        }

        SelectListItem viewAllTags = new SelectListItem();
        viewAllTags.Text = "- tous -";
        viewAllTags.Value = "";
        viewAllTags.Selected = tagFilter == "" ? true : false;
        tagItems.Add(viewAllTags);
        
        foreach (cg_Products_Tags tag in colTags)
        {
            SelectListItem item = new SelectListItem();
            item.Text = tag.Tag;
            item.Value = tag.Tag;
            item.Selected = tagFilter == tag.Tag ? true : false;

            tagItems.Add(item);
        }
    %>

    <h2>Produits</h2>
    
    <div class="on-list-new-form">
        <a href="/manage">< Retour</a> | <a href="javascript:;" onclick="$('.toggle-form').toggle();">Nouveau Produit »</a>
        <div class="toggle-form">
        <% using (Html.BeginForm("product_new", "manage", FormMethod.Post))
           {
               %>
            <%= Html.ValidationSummary(true) %>
            


        <fieldset>
            <legend>Nouveau Produit</legend>
            
            <div class="editor-label">
                <label for="productName">Nom</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("productName", "", new { @class = "required" })%>
                <%= Html.ValidationMessage("productName", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="productCode">Code Produit</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("productCode")%>
                <%= Html.ValidationMessage("productCode", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="DestinationId">Destination</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("DestinationId", destItems)%>
                <%= Html.ValidationMessage("DestinationId", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="ActivityId">Activité</label>
            </div>
            <div class="editor-field">
                <%= Html.DropDownList("ActivityId", activityItems)%>
                <%= Html.ValidationMessage("ActivityId", "*")%>
            </div>
            
            <p>
                <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.toggle-form').hide()">cancel</a>
            </p>
        </fieldset>

        <% } %>
        </div>
    </div>
    

    <% using (Html.BeginForm("products", "manage", FormMethod.Get, new { id = "search" }))
           {
            %>
    <table>
        <tr>
            <td>
                Tags
                <%= Html.DropDownList("tag", tagItems)%>
            </td>
            <td>
                Destination
                <%= Html.DropDownList("destination", destItemsFilter)%>
            </td>
            <td>
                Nom
                <input name="src_productName" value="<%= nameFilter %>" />
            </td>
            <td>
                Code
                <input name="src_productCode" value="<%= codeFilter %>" />
            </td>
            <td>
                <input type="submit" name="submit" value="Rechercher »" />
            </td>
        </tr>
    </table>
    <% } %>

    <table class="full-width list">
        <tr>
            <th></th>
            <th>
                Nom du produit
            </th>
            <th>
                Code Produit
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Nom, code, prix, tags & photos", "product_edit", new { id = item.ProductId })%> |
                <%= Html.ActionLink("Info par langue", "product_infos", new { id=item.ProductId })%> |
                <%= Html.ActionLink("Supprimer", "product_delete", new { id = item.ProductId }, new { @class = "delete_action" })%>
            </td>
            <td>
                <%= Html.Encode(item.Name) %>
            </td>
            <td>
                <%= Html.Encode(item.ProductCode) %>
            </td>
        </tr>
    
    <% } %>

    </table>

</asp:Content>

