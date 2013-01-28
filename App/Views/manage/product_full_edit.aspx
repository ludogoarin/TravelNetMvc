<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/admin.Master" Inherits="System.Web.Mvc.ViewPage<Caval_go.Models.ProductFullInfoByLanguage>" %>
<%@ Import Namespace="Caval_go.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Editer - Produit
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
                    
        <%
            caval_goEntities db = new caval_goEntities();
            
            // make list of select items for RingId's
            List<SelectListItem> ddlLangItems = new List<SelectListItem>();
            Model.Product.cg_Products_Info.Load();
            List<cg_Products_Info> prodInfos = Model.Product.cg_Products_Info.ToList();
            var lgslist = (from pinf in Model.Product.cg_Products_Info
                          join l in db.cg_Languages on pinf.LanguageId equals l.LanguageId into lgs
                          from l in lgs
                          select l).ToList();;

            foreach (var lang in lgslist)
            {
                SelectListItem item = new SelectListItem();
                item.Text = lang.Name;
                item.Value = lang.LanguageId.ToString();
                item.Selected = lang.LanguageId == Model.ProductInfo.LanguageId;

                ddlLangItems.Add(item);
            }
        %>


    <h2><%= Model.Product.Name + " - " + Model.Language.Name %></h2>
    Voir une autre langue pour ce produit: <%= Html.DropDownList("CurrentLanguageId", ddlLangItems, new { onchange = "switchlang_prodfulledit();" })%>

    <% using (Html.BeginForm("product_info_update", "manage", FormMethod.Post, new { @class = "product_info_update" }))
       {%>
        <%= Html.ValidationSummary(true) %>
        
        <fieldset class="fields">

            <div class="top-right-button">
                <input type="submit" value="Sauvegarder" />
            </div>

            <legend>Descriptif - <%= Model.Language.Name%></legend>

            <%= Html.Hidden("ProductInfoId", Model.ProductInfo.ProductInfoId)%>
            <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
            <%= Html.Hidden("LanguageId", Model.ProductInfo.LanguageId)%>
            
            <div class="editor-label">
                <label for="Title">Nom du produit</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("Title", Model.ProductInfo.Title, new { @class = "required" })%>
                <%= Html.ValidationMessage("Title", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="MetaDescription">Meta Description</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaDescription", Model.ProductInfo.MetaDescription)%>
            </div>
            
            <div class="editor-label">
                <label for="MetaKeywords">Meta Keywords</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaKeywords", Model.ProductInfo.MetaKeywords)%>
            </div>
            
            <div class="editor-label">
                <label for="MetaTitle">Meta Title</label>
            </div>
            <div class="editor-field">
                <%= Html.TextArea("MetaTitle", Model.ProductInfo.MetaTitle)%>
            </div>
            
            <div class="editor-label">
                <label for="UrlCustomSegment">URL custom segment</label>
            </div>
            <div class="editor-field">
                <%= Html.TextBox("UrlCustomSegment", Model.ProductInfo.UrlCustomSegment, new { @class = "full-width" })%>
            </div>
            
            <div class="editor-label">
                <label for="ShortDescription">Description courte</label> (<a href="javascript:;" onclick="toggleGenericEditor('ShortDescription');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("ShortDescription", Model.ProductInfo.ShortDescription, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("ShortDescription", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Description">Description</label> (<a href="javascript:;" onclick="toggleGenericEditor('Description');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("Description", Model.ProductInfo.Description, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("Description", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="PricingInfo">Details des tarifs</label> (<a href="javascript:;" onclick="toggleGenericEditor('PricingInfo');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("PricingInfo", Model.ProductInfo.PricingInfo, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("PricingInfo", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="ProductSummary">Résumé produit (apparait en haut a gauche)</label> (<a href="javascript:;" onclick="toggleGenericEditor('ProductSummary');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("ProductSummary", Model.ProductInfo.ProductSummary, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("ProductSummary", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="CustomField1">Infos supplémentaires (apparait en bas a gauche)</label> (<a href="javascript:;" onclick="toggleGenericEditor('CustomField1');">load/unload editor</a>)
            </div>
            <div class="editor-field">
                <%= Html.TextArea("CustomField1", Model.ProductInfo.CustomField1, new { @class = "edit-textarea" })%>
                <%= Html.ValidationMessage("CustomField1", "*")%>
            </div>
            
            <div class="editor-label">
                <label for="Status">Status</label>
            </div>
            <div class="editor-field">
                <select name="Status" id="Status">
                    <option value="active" <%= Model.ProductInfo.Status == "active"? "selected='selected'":"" %>>active</option>
                    <option value="pending" <%= Model.ProductInfo.Status == "pending"? "selected='selected'":"" %>>pending</option>
                </select>
                <%= Html.ValidationMessage("Status", "*")%>
            </div>

        </fieldset>

    <% } %>
        
        <fieldset>
            <legend>Onglets - <%= Model.Language.Name%></legend>
            <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
            <%= Html.Hidden("LanguageId", Model.Language.LanguageId)%>

            <div>
                <a href="javascript:;" onclick="$('.newtabform').toggle();">Nouvel Onglet »</a>

                <% using (Html.BeginForm("product_infotabs_add", "manage", FormMethod.Post, new { @class = "newtabform", style = "display: none;"})) { %>
                    
                    <h3>Nouvel Onglet</h3>

                    <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                    <%= Html.Hidden("LanguageId", Model.Language.LanguageId)%>

                    <div class="editor-label">
                        <label for="NewTabTitle">Nom du nouvel onglet</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("NewTabTitle", "", new { @class = "required" })%>
                        <%= Html.ValidationMessage("NewTabTitle", "*")%>
                    </div>
            
                    <div class="editor-label">
                        <label for="NewTabCode">Contenu de l'onglet</label> (<a href="javascript:;" onclick="toggleGenericEditor('NewTabCode');">load/unload editor</a>)
                    </div>
                    <div class="editor-field">
                        <%= Html.TextArea("NewTabCode", new { @class = "edit-textarea" })%>
                        <%= Html.ValidationMessage("NewTabCode", "*")%>
                    </div>

                    <p>
                        <input type="submit" value="Create" /> or <a href="javascript:;" onclick="$('.newtabform').hide()">cancel</a>
                    </p>

                <% } %>
            </div>
            <br />

            <% foreach (var tab in Model.Tabs)
               { %>
            
                <% using (Html.BeginForm("product_infotabs_update", "manage", FormMethod.Post, new { @class = "product_infotabs_update" })) {%>

                    <%= Html.Hidden("ProductInfoTabId", tab.ProductInfoTabId)%>
                    <%= Html.Hidden("ProductId", Model.Product.ProductId)%>
                    <%= Html.Hidden("LanguageId", Model.Language.LanguageId)%>

                <div class="fields tablist-item">
                    <div class="top-right-button">
                        <input type="submit" value="Sauvegarder" />
                        <input type="button" value="Supprimer" onclick="deleteProductTab(<%=tab.ProductInfoTabId %>, <%=Model.Product.ProductId %>, <%=Model.Language.LanguageId %>);" />
                    </div>

                    <h3><%= tab.ListOrder + " - " + tab.TabTitle %></h3>

                    <div class="editor-label">
                        <label for="TabTitle">Nom de l'onglet</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("TabTitle", tab.TabTitle, new { @class = "required" })%>
                        <%= Html.ValidationMessage("TabTitle", "*")%>
                    </div>

                    <div class="editor-label">
                        <label for="ListOrder">Ordre</label>
                    </div>
                    <div class="editor-field">
                        <%= Html.TextBox("ListOrder", tab.ListOrder, new { @class = "required number small" })%>
                        <%= Html.ValidationMessage("ListOrder", "*")%>
                    </div>
            
                    <div class="editor-label">
                        <label for="TabCode_<%= tab.ProductInfoTabId %>">Contenu de l'onglet</label> (<a href="javascript:;" onclick="toggleGenericEditor('TabCode_<%= tab.ProductInfoTabId %>');">load/unload editor</a>)
                    </div>
                    <div class="editor-field">
                        <textarea id="TabCode_<%= tab.ProductInfoTabId %>" name="TabCode"><%= Html.Encode(tab.TabCode)%></textarea>
                        <%= Html.ValidationMessage("TabCode_" + tab.ProductInfoTabId, "*")%>
                    </div>
                </div>

            <% } %>

            <% } %>
        </fieldset>

    <div>
        <%= Html.ActionLink("< Retour", "product_infos", new { id = Model.Product.ProductId })%>
    </div>

</asp:Content>

