<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<IEnumerable<Caval_go.Models.cg_Products_Info_Tabs>>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	product_info_tabs
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h2>product_info_tabs</h2>

    <table>
        <tr>
            <th></th>
            <th>
                ProductInfoTabId
            </th>
            <th>
                ProductId
            </th>
            <th>
                LanguageId
            </th>
            <th>
                TabTitle
            </th>
            <th>
                TabCode
            </th>
            <th>
                ListOrder
            </th>
        </tr>

    <% foreach (var item in Model) { %>
    
        <tr>
            <td>
                <%= Html.ActionLink("Edit", "Edit", new { id=item.ProductId }) %> |
                <%= Html.ActionLink("Details", "Details", new { id=item.ProductId })%> |
                <%= Html.ActionLink("Delete", "Delete", new { id=item.ProductId })%>
            </td>
            <td>
                <%= Html.Encode(item.ProductInfoTabId) %>
            </td>
            <td>
                <%= Html.Encode(item.ProductId) %>
            </td>
            <td>
                <%= Html.Encode(item.LanguageId) %>
            </td>
            <td>
                <%= Html.Encode(item.TabTitle) %>
            </td>
            <td>
                <%= Html.Encode(item.TabCode) %>
            </td>
            <td>
                <%= Html.Encode(item.ListOrder) %>
            </td>
        </tr>
    
    <% } %>

    </table>

    <p>
        <%= Html.ActionLink("Create New", "Create") %>
    </p>

</asp:Content>

