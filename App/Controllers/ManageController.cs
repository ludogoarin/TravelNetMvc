using System;
using System.Data.Objects;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Globalization;
using Caval_go.Models;


namespace Caval_go.Controllers
{
    [Authorize]
    public class ManageController : Controller
    {
        caval_goEntities db = new caval_goEntities();

        //
        // GET: /Manage/
        public ActionResult Index()
        {
            return View();
        }

        #region Destinations

        public ActionResult destinations()
        {
            var destinationList = db.cg_Destinations;
            return View(destinationList);
        }

        public ActionResult destination(int id)
        {
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult destination_edit(int id)
        {
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult destination_delete(int id)
        {
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("destinations");
        }

        public ActionResult destination_info(int id)
        {
            cg_Destinations_Info item = db.cg_Destinations_Info.Where(destinfo => destinfo.DestinationInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult destination_info_edit(int id)
        {
            cg_Destinations_Info item = db.cg_Destinations_Info.Where(destinfo => destinfo.DestinationInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult destination_infos(int id)
        {
            var destinfos = from dests in db.cg_Destinations_Info
                            where dests.DestinationId == id
                            join l in db.cg_Languages on dests.LanguageId equals l.LanguageId into lgs
                            from l in lgs
                            select new { DestinationInfo = dests, Language = l };

            List<DestinationInfoLanguage> outlist = new List<DestinationInfoLanguage>();

            foreach (var item in destinfos)
            {
                DestinationInfoLanguage listItem = new DestinationInfoLanguage();
                listItem.Language = item.Language;
                listItem.DestinationInfo = item.DestinationInfo;
                outlist.Add(listItem);
            }

            return View(outlist);
        }


        public ActionResult destination_info_delete(int id)
        {
            cg_Destinations_Info item = db.cg_Destinations_Info.Where(dest => dest.DestinationInfoId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("destination_infos", new { id = Request.QueryString["destinationid"] });
        }

        [HttpPost]
        public ActionResult destinations_new(FormCollection collection)
        {
            var newItem = new cg_Destinations();

            // add values
            newItem.Name = collection["destinationName"];

            // add to DB & save
            db.AddTocg_Destinations(newItem);
            db.SaveChanges();

            return RedirectToAction("destinations");
        }

        [HttpPost]
        public JsonResult destinations_update(long destinationId, string updatedName)
        {
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == destinationId).FirstOrDefault();

            // add values
            item.Name = updatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        [HttpPost]
        public JsonResult destinations_update_address(long destinationId, string updatedAddress)
        {
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == destinationId).FirstOrDefault();

            // add values
            item.MapAddress = updatedAddress;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult destinations_info_new(FormCollection collection)
        {
            long DestinationId = Convert.ToInt64(collection["DestinationId"]);
            cg_Destinations item = db.cg_Destinations.Where(dest => dest.DestinationId == DestinationId).FirstOrDefault();

            cg_Destinations_Info itemInfo = new cg_Destinations_Info();

            // add values
            itemInfo.Name = collection["Title"];
            itemInfo.Description = collection["Description"];
            itemInfo.DestinationId = DestinationId;
            itemInfo.MetaDescription = collection["MetaDescription"];
            itemInfo.MetaKeywords = collection["MetaKeywords"];
            itemInfo.MetaTitle = collection["MetaTitle"];
            itemInfo.UrlCustomSegment = collection["UrlCustomSegment"].ToLower();
            itemInfo.ShortDescription = collection["ShortDescription"];
            itemInfo.LanguageId = Convert.ToInt64(collection["LanguageId"]);
            itemInfo.cg_DestinationsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Destinations", "DestinationId", Convert.ToInt64(collection["DestinationId"]));

            // add to DB & save
            db.AddTocg_Destinations_Info(itemInfo);
            db.SaveChanges();

            return RedirectToAction("destination_infos", new { id = DestinationId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult destination_info_edit(FormCollection collection)
        {
            long DestinationInfoId = Convert.ToInt64(collection["DestinationInfoId"]);
            cg_Destinations_Info itemInfo = db.cg_Destinations_Info.Where(destinfo => destinfo.DestinationInfoId == DestinationInfoId).FirstOrDefault();
            long DestinationId = itemInfo.DestinationId;

            // add values
            itemInfo.Name = collection["Title"];
            itemInfo.MetaDescription = collection["MetaDescription"];
            itemInfo.MetaKeywords = collection["MetaKeywords"];
            itemInfo.MetaTitle = collection["MetaTitle"];
            itemInfo.UrlCustomSegment = collection["UrlCustomSegment"].ToLower();
            itemInfo.Description = collection["Description"];
            itemInfo.ShortDescription = collection["ShortDescription"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("destination_infos", new { id = DestinationId });
        }

        #endregion

        #region Languages

        public ActionResult languages()
        {
            var items = db.cg_Languages;
            return View(items);
        }

        public ActionResult language(int id)
        {
            var item = db.cg_Languages.Where(l => l.LanguageId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult language_edit(int id)
        {
            var item = db.cg_Languages.Where(l => l.LanguageId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult language_delete(int id)
        {
            var item = db.cg_Languages.Where(l => l.LanguageId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();

            return RedirectToAction("languages");
        }

        [HttpPost]
        public ActionResult language_new(FormCollection collection)
        {
            var newItem = new cg_Languages();

            // add values
            newItem.Name = collection["languageName"];
            newItem.SystemLocale = collection["systemLocale"];

            // add to DB & save
            db.AddTocg_Languages(newItem);
            db.SaveChanges();

            return RedirectToAction("languages");
        }

        [HttpPost]
        public ActionResult language_edit(FormCollection collection)
        {
            long LanguageId = Convert.ToInt64(collection["LanguageId"]);
            cg_Languages item = db.cg_Languages.Where(l => l.LanguageId == LanguageId).FirstOrDefault();

            // add values
            item.Name = collection["LanguageName"];
            item.SystemLocale = collection["SystemLocale"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("languages");
        }

        #endregion

        #region Translations

        public ActionResult translations()
        {
            TranslationService translSvc = new TranslationService();
            long languageId = 0;
            if (Request.QueryString["lg"] != null)
            {
                languageId = Convert.ToInt64(Request.QueryString["lg"]);
            }

            var view = translSvc.getTransations(languageId);
            return View(view);
        }

        public ActionResult translation(int id)
        {
            var item = db.cg_LanguageTranslations.Where(l => l.LanguageTranslationId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult translation_edit(int id)
        {
            var item = db.cg_LanguageTranslations.Where(l => l.LanguageTranslationId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult translation_delete(int id)
        {
            var item = db.cg_LanguageTranslations.Where(l => l.LanguageTranslationId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();

            return RedirectToAction("translations");
        }

        [HttpPost]
        public ActionResult translation_new(FormCollection collection)
        {
            var newItem = new cg_LanguageTranslations();

            // add values
            newItem.Original = collection["Original"];
            newItem.Translated = collection["Translated"];
            newItem.cg_LanguagesReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Languages", "LanguageId", long.Parse(collection["LanguageId"]));

            // add to DB & save
            db.AddTocg_LanguageTranslations(newItem);
            db.SaveChanges();

            return RedirectToAction("translations");
        }

        [HttpPost]
        public ActionResult translation_edit(FormCollection collection)
        {
            long LanguageTranslationId = Convert.ToInt64(collection["LanguageTranslationId"]);
            var item = db.cg_LanguageTranslations.Where(l => l.LanguageTranslationId == LanguageTranslationId).FirstOrDefault();

            // add values
            item.Original = collection["Original"];
            item.Translated = collection["Translated"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("translations");
        }

        #endregion

        #region Products

        #region General

        public ActionResult products()
        {
            List<cg_Products> items = new List<cg_Products>();
            // filters
            string nameFilter = Request.QueryString["src_productName"];
            string destFilter = Request.QueryString["destination"];
            string codeFilter = Request.QueryString["src_productCode"];
            string tagFilter = Request.QueryString["tag"];

            if (!String.IsNullOrEmpty(destFilter))
            {
                long filterDestinationId = Convert.ToInt64(destFilter);
                cg_Destinations destination = db.cg_Destinations.Where(d => d.DestinationId == filterDestinationId).FirstOrDefault();
                destination.cg_Products.Load();
                items = destination.cg_Products.ToList();
            }
            else
            {
                items = db.cg_Products.ToList();
            }

            if (!String.IsNullOrEmpty(nameFilter))
            {
                items = items.Where(p => p.Name.ToLower().Contains(nameFilter.ToLower()) == true).ToList();
            }

            if (!String.IsNullOrEmpty(codeFilter))
            {
                items = items.Where(p => p.ProductCode.ToLower().Contains(codeFilter.ToLower()) == true).ToList();
            }

            if (!String.IsNullOrEmpty(tagFilter))
            {
                cg_Products_Tags tag = db.cg_Products_Tags.Where(t => t.Tag.ToLower() == tagFilter.ToLower()).FirstOrDefault();
                tag.cg_Products_Tags_Map.Load();

                items = items.Where(p => p.cg_Products_Tags_Map.Where(tm => tm.cg_Products_TagsReference.Value.ProductTagId == tag.ProductTagId).Count() > 0).ToList();
            }

            return View(items.OrderBy(p => p.Name));
        }

        public ActionResult product(int id)
        {
            var item = db.cg_Products.Where(p => p.ProductId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult product_edit(int id)
        {
            ProductService pSrv = new ProductService();
            ProductFullInfo product = pSrv.getProductFullInfo(id);
            return View(product);
        }

        public ActionResult product_delete(int id)
        {
            var item = db.cg_Products.Where(p => p.ProductId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();

            return RedirectToAction("products");
        }

        [HttpPost]
        public ActionResult product_new(FormCollection collection)
        {
            var newItem = new cg_Products();

            // add values
            newItem.Name = collection["productName"];
            newItem.ProductCode = collection["productCode"];
            newItem.cg_DestinationsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Destinations", "DestinationId", long.Parse(collection["DestinationId"]));

            // add to DB & save
            db.AddTocg_Products(newItem);
            db.SaveChanges();

            return RedirectToAction("products");
        }

        [HttpPost]
        public ActionResult product_edit(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            var item = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();

            // add values
            item.Name = collection["Product.Name"];
            item.ProductCode = collection["Product.ProductCode"];
            item.Price = Convert.ToDecimal(collection["Product.Price"]);
            Boolean allYearRound = Convert.ToBoolean(collection["Product.AllYearRound"].Split(',')[0]);
            item.AllYearRound = allYearRound;
            item.Duration = Convert.ToInt32(collection["Product.Duration"]);
            item.cg_DestinationsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Destinations", "DestinationId", long.Parse(collection["DestinationId"]));

            // save DB
            db.SaveChanges();

            return RedirectToAction("products");
        }

        public ActionResult product_infos(int id)
        {
            List<ProductInfos_Language> prodinfo_lg = new List<ProductInfos_Language>();
            var qpl = from prodinfos in db.cgvw_ProductInfoLanguage
                      where prodinfos.ProductId == id
                      select prodinfos;

            return View(qpl);
        }

        public ActionResult product_info_edit(int id)
        {
            ProductService pSrv = new ProductService();
            ProductFullInfo product = pSrv.getProductFullInfo(id);
            return View(product);
        }

        public ActionResult product_info_delete(int id)
        {
            var item = db.cg_Products_Info.Where(pi => pi.ProductInfoId == id).FirstOrDefault();
            long productId = item.ProductId;

            db.DeleteObject(item);
            db.SaveChanges();

            return RedirectToAction("product_infos", new { id = productId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult product_info_add(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            long LanguageId = Convert.ToInt64(collection["LanguageId"]);
            var item = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();

            var newItem = new cg_Products_Info();

            // add values
            newItem.Title = collection["Title"];
            newItem.ShortDescription = collection["ShortDescription"];
            newItem.Description = collection["Description"];
            newItem.Status = collection["Status"];
            newItem.LanguageId = LanguageId;
            newItem.cg_ProductsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Products", "ProductId", ProductId);

            // add to DB & save
            db.AddTocg_Products_Info(newItem);
            db.SaveChanges();

            return RedirectToAction("product_infos", new { id = ProductId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult product_info_update(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            long LanguageId = Convert.ToInt64(collection["LanguageId"]);
            var item = db.cg_Products_Info.Where(pi => pi.ProductId == ProductId && pi.LanguageId == LanguageId).FirstOrDefault();

            // add values
            item.Title = collection["Title"];
            item.MetaDescription = collection["MetaDescription"];
            item.MetaKeywords = collection["MetaKeywords"];
            item.MetaTitle = collection["MetaTitle"];
            item.UrlCustomSegment = collection["UrlCustomSegment"].ToLower();
            item.ShortDescription = collection["ShortDescription"];
            item.Description = collection["Description"];
            item.Status = collection["Status"];
            item.PricingInfo = collection["PricingInfo"];
            item.ProductSummary = collection["ProductSummary"];
            item.CustomField1 = collection["CustomField1"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("product_full_edit", new { id = ProductId, lid = LanguageId });
        }

        public ActionResult product_full_edit(int id)
        {
            ProductService pSrv = new ProductService();
            long languageId = Convert.ToInt64(Request.QueryString["lid"]);
            ProductFullInfoByLanguage pInfoLang = pSrv.getEditProductFullInfoByLanguage(id, languageId);
            return View(pInfoLang);
        }

        #endregion

        #region Photos

        [HttpPost]
        public ActionResult product_photos_add(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            cg_Products product = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            cg_Products_Photos newItem = new cg_Products_Photos();

            // Get file
            HttpPostedFileBase file = Request.Files["OriginalFileName"];
            //Response.Write("Request.Files: " + Request.Files.Count);
            //Response.End();

            string fileExtension = Path.GetExtension(file.FileName);

            // Add mockup info
            newItem.OriginalFileName = file.FileName;
            newItem.Description = collection["Description"];
            newItem.FileExtension = fileExtension;

            // Add object
            product.cg_Products_Photos.Add(newItem);
            db.SaveChanges();

            if (file.ContentLength > 0)
            {
                string filePath = Path.Combine(HttpContext.Server.MapPath("~/content/galleries/items"), newItem.ProductPhotoId + fileExtension);
                file.SaveAs(filePath);
            }

            return RedirectToAction("product", new { id = ProductId });
        }

        public ActionResult product_photo_delete(long id)
        {
            long ProductId = Convert.ToInt64(Request.QueryString["prodid"]);

            // get the photo
            cg_Products_Photos photo = db.cg_Products_Photos.Where(p => p.ProductPhotoId == id).FirstOrDefault();

            // delete the file
            string filePath = Server.MapPath("~/content/trip-photos/" + id + photo.FileExtension);
            System.IO.File.Delete(filePath);

            // delete the database record
            db.DeleteObject(photo);
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("product_edit", new { id = ProductId });
        }

        [HttpPost]
        public ActionResult product_photo_neworder(FormCollection collection)
        {
            long ProductPhotoId = Convert.ToInt64(collection["ProductPhotoId"]);
            int ListOrder = Convert.ToInt32(collection["ListOrder"]);
            long ProductId = Convert.ToInt64(collection["ProductId"]);

            // get the photo
            cg_Products_Photos photo = db.cg_Products_Photos.Where(p => p.ProductPhotoId == ProductPhotoId).FirstOrDefault();

            // update values
            photo.ListOrder = ListOrder;
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("product_edit", new { id = ProductId });
        }

        [HttpPost]
        public ActionResult product_photo_newcaption(FormCollection collection)
        {
            long ProductPhotoId = Convert.ToInt64(collection["ProductPhotoId"]);
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            string Description = collection["Description"];

            // get the photo
            cg_Products_Photos photo = db.cg_Products_Photos.Where(p => p.ProductPhotoId == ProductPhotoId).FirstOrDefault();

            // update values
            photo.Description = Description;
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("product_edit", new { id = ProductId });
        }

        [HttpPost]
        public ActionResult product_photo_new(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            cg_Products product = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            cg_Products_Photos ppItem = new cg_Products_Photos();

            // Get file
            HttpPostedFileBase file = Request.Files["OriginalFileName"];
            string fileExtension = Path.GetExtension(file.FileName);

            // Add file info
            ppItem.ListOrder = Convert.ToInt32(collection["ListOrder"]);
            ppItem.OriginalFileName = file.FileName;
            ppItem.Description = collection["Description"];
            ppItem.FileExtension = fileExtension;

            // Add object
            product.cg_Products_Photos.Add(ppItem);

            // Save to DB and get the new ID
            db.SaveChanges();

            if (file.ContentLength > 0)
            {
                string filePath = Path.Combine(HttpContext.Server.MapPath("~/content/trip-photos"), ppItem.ProductPhotoId + fileExtension);
                file.SaveAs(filePath);
            }

            return RedirectToAction("product_edit", new { id = ProductId });
        }

        #endregion

        #region Dates

        public ActionResult product_dates_edit(long id)
        {
            long ProductDateId = Convert.ToInt64(Request.QueryString["prodid"]);

            // get the item
            cg_Products_Dates item = db.cg_Products_Dates.Where(d => d.ProductDateId == id).FirstOrDefault();

            return View(item);
        }

        [HttpPost]
        public ActionResult product_dates_add(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            cg_Products product = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            cg_Products_Dates newItem = new cg_Products_Dates();

            // Add item info
            string[] dep_date = collection["date_departure"].Split('/');
            int dep_year = Convert.ToInt32(dep_date[2]);
            int dep_month = Convert.ToInt32(dep_date[1]);
            int dep_day = Convert.ToInt32(dep_date[0]);

            string[] ret_date = collection["date_return"].Split('/');
            int ret_year = Convert.ToInt32(ret_date[2]);
            int ret_month = Convert.ToInt32(ret_date[1]);
            int ret_day = Convert.ToInt32(ret_date[0]);

            newItem.DepartureDate = new DateTime(dep_year, dep_month, dep_day);
            newItem.ReturnDate = new DateTime(ret_year, ret_month, ret_day);
            newItem.Price = Convert.ToDecimal(collection["date_price"]);
            newItem.FlightPrice = Convert.ToDecimal(collection["flight_price"]);
            newItem.Note = "";
            newItem.MiniPersons = Convert.ToInt32(collection["mini_pers"]);

            // Add object
            product.cg_Products_Dates.Add(newItem);
            db.SaveChanges();

            return RedirectToAction("product_edit", new { id = ProductId });
        }

        [HttpPost]
        public ActionResult product_dates_edit(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            long ProductDateId = Convert.ToInt64(collection["ProductDateId"]);
            cg_Products_Dates item = db.cg_Products_Dates.Where(d => d.ProductDateId == ProductDateId).FirstOrDefault();

            // Add item info
            string[] dep_date = collection["date_departure"].Split('/');
            int dep_year = Convert.ToInt32(dep_date[2]);
            int dep_month = Convert.ToInt32(dep_date[1]);
            int dep_day = Convert.ToInt32(dep_date[0]);

            string[] ret_date = collection["date_return"].Split('/');
            int ret_year = Convert.ToInt32(ret_date[2]);
            int ret_month = Convert.ToInt32(ret_date[1]);
            int ret_day = Convert.ToInt32(ret_date[0]);

            item.DepartureDate = new DateTime(dep_year, dep_month, dep_day);
            item.ReturnDate = new DateTime(ret_year, ret_month, ret_day);
            item.Price = Convert.ToDecimal(collection["date_price"]);
            item.FlightPrice = Convert.ToDecimal(collection["flight_price"]);
            item.Note = "";
            item.MiniPersons = Convert.ToInt32(collection["mini_pers"]);

            // Save changes
            db.SaveChanges();

            return RedirectToAction("product_edit", new { id = ProductId });
        }

        public ActionResult product_dates_delete(long id)
        {
            long ProductId = Convert.ToInt64(Request.QueryString["prodid"]);

            // get the item
            cg_Products_Dates item = db.cg_Products_Dates.Where(d => d.ProductDateId == id).FirstOrDefault();

            // delete the database record
            db.DeleteObject(item);
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("product_edit", new { id = ProductId });
        }

        #endregion

        #region TABS

        public ActionResult product_info_tabs(int id)
        {
            long languageId = Convert.ToInt64(Request.QueryString["lid"]);
            var ProductInfo = db.cg_Products_Info.Where(pi => pi.LanguageId == languageId && pi.ProductId == id).FirstOrDefault();
            ProductInfo.cg_Products_Info_Tabs.Load();

            return View(ProductInfo.cg_Products_Info_Tabs);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult product_infotabs_add(FormCollection collection)
        {
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            long languageId = Convert.ToInt64(collection["LanguageId"]);
            var item = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            var ProductInfo = db.cg_Products_Info.Where(pi => pi.LanguageId == languageId && pi.ProductId == ProductId).FirstOrDefault();

            var newItem = new cg_Products_Info_Tabs();

            // get new ListOrder
            ProductInfo.cg_Products_Info_Tabs.Load();
            var listOrder = (from itabs in ProductInfo.cg_Products_Info_Tabs
                             select itabs.ListOrder).Max();

            // add values
            newItem.TabTitle = collection["NewTabTitle"];
            newItem.TabCode = collection["NewTabCode"];
            newItem.ListOrder = listOrder + 1;

            // add to DB & save
            ProductInfo.cg_Products_Info_Tabs.Add(newItem);
            db.SaveChanges();

            return RedirectToAction("product_full_edit", new { id = ProductId, lid = languageId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult product_infotabs_update(FormCollection collection)
        {
            long ProductInfoTabId = Convert.ToInt64(collection["ProductInfoTabId"]);
            long ProductId = Convert.ToInt64(collection["ProductId"]);
            long LanguageId = Convert.ToInt64(collection["LanguageId"]);
            var item = db.cg_Products_Info_Tabs.Where(pit => pit.ProductInfoTabId == ProductInfoTabId).FirstOrDefault();

            // add values
            item.TabTitle = collection["TabTitle"];
            item.TabCode = collection["TabCode"];
            item.ListOrder = Convert.ToInt32(collection["ListOrder"]);

            // save to DB
            db.SaveChanges();

            return RedirectToAction("product_full_edit", new { id = ProductId, lid = LanguageId });
        }
        public ActionResult product_infotabs_delete()
        {
            long ProductInfoTabId = Convert.ToInt64(Request.QueryString["ProductInfoTabId"]);
            long ProductId = Convert.ToInt64(Request.QueryString["ProductId"]);
            long LanguageId = Convert.ToInt64(Request.QueryString["LanguageId"]);
            var item = db.cg_Products_Info_Tabs.Where(pit => pit.ProductInfoTabId == ProductInfoTabId).FirstOrDefault();

            // save to DB
            db.DeleteObject(item);
            db.SaveChanges();

            return RedirectToAction("product_full_edit", new { id = ProductId, lid = LanguageId });
        }

        #endregion

        #region Tags

        [HttpPost]
        public ActionResult product_tags_update(FormCollection collection)
        {

            long ProductId = Convert.ToInt64(collection["ProductId"]);
            cg_Products product = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            string[] tags = collection["productTag"].Split(',');

            // load existing tags
            product.cg_Products_Tags_Map.Load();
            var tagList = product.cg_Products_Tags_Map.ToList();

            // remove all existing tags
            foreach (cg_Products_Tags_Map tagmap in tagList)
            {
                if (!tags.Contains(tagmap.ProductTagId.ToString()))
                {
                    db.DeleteObject(tagmap);
                }
                else
                {
                    tags = tags.Where(val => val != tagmap.ProductTagId.ToString()).ToArray();
                }
            }

            // create a collection of the new tag list
            foreach (string sTagId in tags)
            {
                if (sTagId != "false")
                {
                    long tagId = Convert.ToInt64(sTagId);

                    // create the new object
                    cg_Products_Tags_Map tmap = new cg_Products_Tags_Map() { ProductId = ProductId, ProductTagId = tagId };

                    tmap.cg_ProductsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Products", "ProductId", ProductId);
                    tmap.cg_Products_TagsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Products_Tags", "ProductTagId", tagId);

                    // add object to collection
                    db.AddTocg_Products_Tags_Map(tmap);

                    Response.Write("TagId: " + tagId + "<br /> ProductId: " + ProductId + "<hr />");
                }
            }

            // save changes to DB
            db.SaveChanges();

            return RedirectToAction("product_edit", new { id = ProductId });
        }

        #endregion

        #region Activity Map

        [HttpPost]
        public ActionResult product_activities_update(FormCollection collection)
        {

            long ProductId = Convert.ToInt64(collection["ProductId"]);
            cg_Products product = db.cg_Products.Where(p => p.ProductId == ProductId).FirstOrDefault();
            string[] activityIds = collection["productActivity"].Split(',');

            // load existing tags
            product.cg_Products_Activities_Map.Load();
            var activityList = product.cg_Products_Activities_Map.ToList();

            // remove all existing tags
            foreach (cg_Products_Activities_Map actmap in activityList)
            {
                if (!activityIds.Contains(actmap.ProductActivityMapId.ToString()))
                {
                    db.DeleteObject(actmap);
                }
                else
                {
                    activityIds = activityIds.Where(val => val != actmap.ProductActivityMapId.ToString()).ToArray();
                }
            }

            // create a collection of the new tag list
            foreach (string sActivityId in activityIds)
            {
                if (sActivityId != "false")
                {
                    long activityId = Convert.ToInt64(sActivityId);

                    // create the new object
                    //cg_Products_Activities_Map tmap = new cg_Products_Activities_Map() {  = ProductId, ProductTagId = activityId };
                    cg_Products_Activities_Map amap = new cg_Products_Activities_Map();

                    amap.cg_ProductsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Products", "ProductId", ProductId);
                    amap.cg_ActivitiesReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Activities", "ActivityId", activityId);

                    // add object to collection
                    db.AddTocg_Products_Activities_Map(amap);

                    //Response.Write("TagId: " + tagId + "<br /> ProductId: " + ProductId + "<hr />");
                }
            }

            // save changes to DB
            db.SaveChanges();

            return RedirectToAction("product_edit", new { id = ProductId });
        }

        #endregion

        #endregion

        #region Product Tags

        public ActionResult tags()
        {
            var tagList = db.cg_Products_Tags;
            return View(tagList);
        }

        public ActionResult tag(int id)
        {
            cg_Products_Tags item = db.cg_Products_Tags.Where(t => t.ProductTagId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult tag_edit(int id)
        {
            cg_Products_Tags item = db.cg_Products_Tags.Where(t => t.ProductTagId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult tag_delete(int id)
        {
            cg_Products_Tags item = db.cg_Products_Tags.Where(t => t.ProductTagId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("tags");
        }

        [HttpPost]
        public ActionResult tags_new(FormCollection collection)
        {
            var newItem = new cg_Products_Tags();

            // add values
            newItem.Tag = collection["tag"];
            newItem.Type = collection["tagType"];

            // add to DB & save
            db.AddTocg_Products_Tags(newItem);
            db.SaveChanges();

            return RedirectToAction("tags");
        }

        [HttpPost]
        public JsonResult tag_update(long ProductTagId, string UpdatedName)
        {
            var item = db.cg_Products_Tags.Where(t => t.ProductTagId == ProductTagId).FirstOrDefault();

            // add values
            item.Tag = UpdatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        public ActionResult tag_info(int id)
        {
            cg_Products_Tags_Info item = db.cg_Products_Tags_Info.Where(info => info.ProductTagInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult tag_info_edit(int id)
        {
            cg_Products_Tags_Info item = db.cg_Products_Tags_Info.Where(info => info.ProductTagInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult tag_infos(int id)
        {
            var items = db.cg_Products_Tags_Info.Where(info => info.ProductTagId == id);

            var destinfos = from tags in db.cg_Products_Tags_Info
                            where tags.ProductTagId == id
                            join l in db.cg_Languages on tags.LanguageId equals l.LanguageId into lgs
                            from l in lgs
                            select new { TagInfo = tags, Language = l };

            List<TagInfoLanguage> outlist = new List<TagInfoLanguage>();

            foreach (var item in destinfos)
            {
                TagInfoLanguage listItem = new TagInfoLanguage();
                listItem.Language = item.Language;
                listItem.TagInfo = item.TagInfo;
                outlist.Add(listItem);
            }

            return View(outlist);
        }

        public ActionResult tag_info_delete(int id)
        {
            cg_Products_Tags_Info item = db.cg_Products_Tags_Info.Where(info => info.ProductTagInfoId == id).FirstOrDefault();
            long tagId = item.ProductTagId;
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("tag_infos", new { id = tagId });
        }

        [HttpPost]
        public JsonResult tagInfo_update(long ProductTagInfoId, string UpdatedName)
        {
            var item = db.cg_Products_Tags_Info.Where(t => t.ProductTagInfoId == ProductTagInfoId).FirstOrDefault();

            // add values
            item.Name = UpdatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        [HttpPost]
        public ActionResult tags_info_new(FormCollection collection)
        {
            long ProductTagId = Convert.ToInt64(collection["ProductTagId"]);
            cg_Products_Tags item = db.cg_Products_Tags.Where(tag => tag.ProductTagId == ProductTagId).FirstOrDefault();

            cg_Products_Tags_Info itemInfo = new cg_Products_Tags_Info();

            // add values
            itemInfo.Name = collection["tagName"];
            itemInfo.Description = ""; // collection["Description"];
            itemInfo.LanguageId = Convert.ToInt64(collection["LanguageId"]);
            itemInfo.cg_Products_TagsReference.EntityKey = new System.Data.EntityKey("caval_goEntities.cg_Products_Tags", "ProductTagId", ProductTagId);

            // add to DB & save
            db.AddTocg_Products_Tags_Info(itemInfo);
            db.SaveChanges();

            return RedirectToAction("tag_infos", new { id = ProductTagId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult tag_info_edit(FormCollection collection)
        {
            long ProductTagInfoId = Convert.ToInt64(collection["ProductTagInfoId"]);
            cg_Products_Tags_Info itemInfo = db.cg_Products_Tags_Info.Where(info => info.ProductTagInfoId == ProductTagInfoId).FirstOrDefault();

            // add values
            itemInfo.Name = collection["tagName"];
            itemInfo.Description = collection["Description"];

            // save DB
            db.SaveChanges();

            // redirect
            return RedirectToAction("tag_infos", new { id = itemInfo.ProductTagId });
        }

        #endregion

        #region CMS Pages

        public ActionResult cms_pages()
        {
            var itemList = db.cg_cms_Pages;
            return View(itemList);
        }

        public ActionResult cms_page(int id)
        {
            cg_cms_Pages item = db.cg_cms_Pages.Where(p => p.PageId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult cms_page_edit(int id)
        {
            cg_cms_Pages item = db.cg_cms_Pages.Where(p => p.PageId == id).FirstOrDefault();
            return View(item);
        }

        [HttpPost]
        public JsonResult cms_page_update(long pageId, string updatedName)
        {
            var item = db.cg_cms_Pages.Where(p => p.PageId == pageId).FirstOrDefault();

            // add values
            item.Name = updatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        public ActionResult cms_page_delete(int id)
        {
            cg_cms_Pages item = db.cg_cms_Pages.Where(p => p.PageId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("cms_pages");
        }

        public ActionResult cms_page_info(int id)
        {
            cg_cms_Pages_Info item = db.cg_cms_Pages_Info.Where(pi => pi.CmsPageInfoId == id).FirstOrDefault();
            return View(item);
        }


        public ActionResult cms_page_info_edit(int id)
        {
            cg_cms_Pages_Info item = db.cg_cms_Pages_Info.Where(pi => pi.CmsPageInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult cms_page_infos(int id)
        {
            var pageinfos = from pgs in db.cg_cms_Pages_Info
                            where pgs.CmsPageId == id
                            join l in db.cg_Languages on pgs.LanguageId equals l.LanguageId into lgs
                            from l in lgs
                            select new { CmsPageInfo = pgs, Language = l, CmsPage = pgs.cg_cms_Pages };

            List<CmsPageInfoLanguage> cmspl = new List<CmsPageInfoLanguage>();

            foreach (var item in pageinfos)
            {
                CmsPageInfoLanguage listItem = new CmsPageInfoLanguage();
                listItem.Language = item.Language;
                listItem.CmsPageInfo = item.CmsPageInfo;
                listItem.CmsPage = item.CmsPage;
                cmspl.Add(listItem);
            }

            return View(cmspl);
        }

        public ActionResult cms_page_info_delete(int id)
        {
            cg_cms_Pages_Info item = db.cg_cms_Pages_Info.Where(pi => pi.CmsPageInfoId == id).FirstOrDefault();
            long pageId = item.CmsPageId;
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("cms_page_infos", new { id = pageId });
        }

        [HttpPost]
        public ActionResult cms_page_new(FormCollection collection)
        {
            var newItem = new cg_cms_Pages();

            // add values
            newItem.Name = collection["pageName"];

            // add to DB & save
            db.AddTocg_cms_Pages(newItem);
            db.SaveChanges();

            return RedirectToAction("cms_pages");
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult cms_page_info_add(FormCollection collection)
        {
            long pageId = Convert.ToInt64(collection["PageId"]);
            cg_cms_Pages item = db.cg_cms_Pages.Where(p => p.PageId == pageId).FirstOrDefault();

            cg_cms_Pages_Info itemInfo = new cg_cms_Pages_Info();

            // add values
            itemInfo.Name = collection["pageName"];
            itemInfo.Code = collection["Code"];
            itemInfo.Tag_Description = collection["Tag_Description"];
            itemInfo.Tag_Keywords = collection["Tag_Keywords"];
            itemInfo.Tag_Title = collection["Tag_Title"];
            itemInfo.LanguageId = Convert.ToInt64(collection["LanguageId"]);

            // add to DB & save
            item.cg_cms_Pages_Info.Add(itemInfo);
            db.SaveChanges();

            return RedirectToAction("cms_page_infos", new { id = pageId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult cms_page_info_edit(FormCollection collection)
        {
            long PageInfoId = Convert.ToInt64(collection["CmsPageInfoId"]);
            cg_cms_Pages_Info itemInfo = db.cg_cms_Pages_Info.Where(pi => pi.CmsPageInfoId == PageInfoId).FirstOrDefault();

            // add values
            itemInfo.Name = collection["pageName"];
            itemInfo.Code = collection["Code"];
            itemInfo.Tag_Description = collection["Tag_Description"];
            itemInfo.Tag_Keywords = collection["Tag_Keywords"];
            itemInfo.Tag_Title = collection["Tag_Title"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("cms_page_infos", new { id = itemInfo.CmsPageId });
        }

        #endregion

        #region CMS Static Blocks

        public ActionResult cms_staticblocks()
        {
            var itemList = db.cg_cms_StaticBlocks.OrderBy(sb => sb.Name);
            return View(itemList);
        }

        public ActionResult cms_staticblock(int id)
        {
            var item = db.cg_cms_StaticBlocks.Where(b => b.StaticBlockId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult cms_staticblock_edit(int id)
        {
            var item = db.cg_cms_StaticBlocks.Where(b => b.StaticBlockId == id).FirstOrDefault();
            return View(item);
        }

        [HttpPost]
        public JsonResult cms_staticblock_update(long blockId, string updatedName)
        {
            var item = db.cg_cms_StaticBlocks.Where(b => b.StaticBlockId == blockId).FirstOrDefault();

            // add values
            item.Name = updatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        public ActionResult cms_staticblock_delete(int id)
        {
            var item = db.cg_cms_StaticBlocks.Where(b => b.StaticBlockId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("cms_staticblocks");
        }

        public ActionResult cms_staticblock_info(int id)
        {
            var item = db.cg_cms_StaticBlocks_Info.Where(sbi => sbi.StaticBlockInfoId == id).FirstOrDefault();
            return View(item);
        }


        public ActionResult cms_staticblock_info_edit(int id)
        {
            var item = db.cg_cms_StaticBlocks_Info.Where(sbi => sbi.StaticBlockInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult cms_staticblock_infos(int id)
        {
            var infos = from sbis in db.cg_cms_StaticBlocks_Info
                            where sbis.StaticBlockId == id
                            join l in db.cg_Languages on sbis.LanguageId equals l.LanguageId into lgs
                            from l in lgs
                            select new { BlockInfo = sbis, Language = l, Block = sbis.cg_cms_StaticBlocks };

            var itemList = new List<CmsStaticBlockInfoLanguage>();

            foreach (var item in infos)
            {
                var listItem = new CmsStaticBlockInfoLanguage();
                listItem.Language = item.Language;
                listItem.BlockInfo = item.BlockInfo;
                listItem.Block = item.Block;
                itemList.Add(listItem);
            }

            return View(itemList);
        }

        public ActionResult cms_staticblock_info_delete(int id)
        {
            var item = db.cg_cms_StaticBlocks_Info.Where(sbi => sbi.StaticBlockInfoId == id).FirstOrDefault();
            long blockId = item.StaticBlockId;
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("cms_staticblock_infos", new { id = blockId });
        }

        [HttpPost]
        public ActionResult cms_staticblock_new(FormCollection collection)
        {
            var newItem = new cg_cms_StaticBlocks();

            // add values
            newItem.Name = collection["blockName"];

            // add to DB & save
            db.AddTocg_cms_StaticBlocks(newItem);
            db.SaveChanges();

            return RedirectToAction("cms_staticblocks");
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult cms_staticblock_info_add(FormCollection collection)
        {
            long blockId = Convert.ToInt64(collection["BlockId"]);
            var item = db.cg_cms_StaticBlocks.Where(sb => sb.StaticBlockId == blockId).FirstOrDefault();

            var itemInfo = new cg_cms_StaticBlocks_Info();

            // add values
            itemInfo.Code = collection["Code"];
            itemInfo.LanguageId = Convert.ToInt64(collection["LanguageId"]);

            // add to DB & save
            item.cg_cms_StaticBlocks_Info.Add(itemInfo);
            db.SaveChanges();

            return RedirectToAction("cms_staticblock_infos", new { id = blockId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult cms_staticblock_info_edit(FormCollection collection)
        {
            long StaticBlockInfoId = Convert.ToInt64(collection["StaticBlockInfoId"]);
            var itemInfo = db.cg_cms_StaticBlocks_Info.Where(sbi => sbi.StaticBlockInfoId == StaticBlockInfoId).FirstOrDefault();

            // add values
            itemInfo.Code = collection["Code"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("cms_staticblock_infos", new { id = itemInfo.StaticBlockId });
        }

        #endregion

        #region Activities

        public ActionResult activities()
        {
            var itemList = db.cg_Activities;
            return View(itemList);
        }

        public ActionResult activity(int id)
        {
            cg_Activities item = db.cg_Activities.Where(act => act.ActivityId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult activity_edit(int id)
        {
            cg_Activities item = db.cg_Activities.Where(act => act.ActivityId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult activity_delete(int id)
        {
            cg_Activities item = db.cg_Activities.Where(act => act.ActivityId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("activities");
        }

        public ActionResult activity_info(int id)
        {
            cg_Activities_Info item = db.cg_Activities_Info.Where(actinfo => actinfo.ActivityInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult activity_info_edit(int id)
        {
            cg_Activities_Info item = db.cg_Activities_Info.Where(actinfo => actinfo.ActivityInfoId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult activity_infos(int id)
        {
            var infos = from actvts in db.cg_Activities_Info
                        where actvts.ActivityId == id
                        join l in db.cg_Languages on actvts.LanguageId equals l.LanguageId into lgs
                            from l in lgs
                        select new { ActivityInfo = actvts, Language = l };

            List<ActivityInfoLanguage> outlist = new List<ActivityInfoLanguage>();

            foreach (var item in infos)
            {
                ActivityInfoLanguage listItem = new ActivityInfoLanguage();
                listItem.Language = item.Language;
                listItem.ActivityInfo = item.ActivityInfo;
                outlist.Add(listItem);
            }

            return View(outlist);
        }

        public ActionResult activity_info_delete(int id)
        {
            cg_Activities_Info item = db.cg_Activities_Info.Where(actinfo => actinfo.ActivityInfoId == id).FirstOrDefault();
            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("activity_infos", new { id = Request.QueryString["activityid"] });
        }

        [HttpPost]
        public ActionResult activities_new(FormCollection collection)
        {
            var newItem = new cg_Activities();

            // add values
            newItem.Name = collection["activityName"];

            // add to DB & save
            db.AddTocg_Activities(newItem);
            db.SaveChanges();

            return RedirectToAction("activities");
        }

        [HttpPost]
        public JsonResult activity_update(long activityId, string updatedName)
        {
            cg_Activities item = db.cg_Activities.Where(act => act.ActivityId == activityId).FirstOrDefault();

            // add values
            item.Name = updatedName;

            // add to DB & save
            db.SaveChanges();

            return this.Json("success", JsonRequestBehavior.DenyGet);
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult activities_info_new(FormCollection collection)
        {
            long ActivityId = Convert.ToInt64(collection["ActivityId"]);
            cg_Activities item = db.cg_Activities.Where(act => act.ActivityId == ActivityId).FirstOrDefault();

            cg_Activities_Info itemInfo = new cg_Activities_Info();

            // add values
            itemInfo.Name = collection["activityName"];
            itemInfo.ShortDescription = collection["ShortDescription"];
            itemInfo.Description = collection["Description"];
            itemInfo.LanguageId = Convert.ToInt64(collection["LanguageId"]);

            // add to DB & save
            item.cg_Activities_Info.Add(itemInfo);
            db.SaveChanges();

            return RedirectToAction("activity_infos", new { id = ActivityId });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult activity_info_edit(FormCollection collection)
        {
            long ActivityInfoId = Convert.ToInt64(collection["ActivityInfoId"]);
            cg_Activities_Info itemInfo = db.cg_Activities_Info.Where(actinfo => actinfo.ActivityInfoId == ActivityInfoId).FirstOrDefault();
            long ActivityId = itemInfo.ActivityId;

            // add values
            itemInfo.Name = collection["activityName"];
            itemInfo.Description = collection["Description"];
            itemInfo.ShortDescription = collection["ShortDescription"];

            // save DB
            db.SaveChanges();

            return RedirectToAction("activity_infos", new { id = ActivityId });
        }

        #endregion

        #region Site Photos

        public ActionResult site_photos(long parentId, string photoType)
        {
            var photos = (from sp in db.cg_SitePhotos
                          where sp.ParentId == parentId && sp.PhotoType == photoType
                          select sp).OrderBy(sp => sp.ListOrder);

            return View(photos);
        }

        [HttpPost]
        public ActionResult site_photo_new(FormCollection collection)
        {
            long parentId = Convert.ToInt64(collection["ParentId"]);
            string photoType = collection["PhotoType"];

            cg_SitePhotos newItem = new cg_SitePhotos();

            // Get file
            HttpPostedFileBase file = Request.Files["OriginalFileName"];
            string fileExtension = Path.GetExtension(file.FileName);

            // Add file info
            newItem.OriginalFileName = file.FileName;
            newItem.Description = collection["Description"];
            newItem.FileExtension = fileExtension;
            newItem.PhotoType = collection["PhotoType"];
            newItem.ParentId = parentId;
            newItem.FileSize = file.ContentLength;

            // Add object
            db.AddTocg_SitePhotos(newItem);
            db.SaveChanges();

            if (file.ContentLength > 0)
            {
                string filePath = Path.Combine(HttpContext.Server.MapPath("~/content/site-photos"), newItem.SitePhotoId + fileExtension);
                file.SaveAs(filePath);
            }

            // Redirect user
            return RedirectToAction("site_photos", new { parentId = parentId, photoType = photoType });
        }

        [HttpPost]
        [ValidateInput(false)]
        public ActionResult site_photo_edit(FormCollection collection)
        {
            long parentId = Convert.ToInt64(collection["ParentId"]);
            long SitePhotoId = Convert.ToInt64(collection["SitePhotoId"]);
            string photoType = collection["PhotoType"];

            // get the photo
            cg_SitePhotos item = db.cg_SitePhotos.Where(p => p.SitePhotoId == SitePhotoId).FirstOrDefault();

            // Add file info
            item.Description = collection["Description"];
            item.Link = collection["Link"];
            item.AlternativeText = collection["AlternativeText"];

            // Save changes to DB
            db.SaveChanges();

            // Redirect user
            return RedirectToAction("site_photos", new { parentId = parentId, photoType = photoType });
        }

        public ActionResult site_photo_delete(long id)
        {
            long parentId = Convert.ToInt64(Request.QueryString["parentid"]);
            string photoType = Request.QueryString["photoType"];

            // call delete function
            site_photo_delete_fn(id, photoType);

            // redirect to list view
            return RedirectToAction("site_photos", new { parentId = parentId, photoType = photoType });
        }

        public ActionResult site_photo_edit(long id)
        {
            long parentId = Convert.ToInt64(Request.QueryString["parentid"]);
            string photoType = Request.QueryString["photoType"];

            // get the photo
            cg_SitePhotos photo = db.cg_SitePhotos.Where(p => p.SitePhotoId == id).FirstOrDefault();

            // redirect to list view
            return View(photo);
        }

        public void site_photo_delete_fn(long id, string photoType)
        {
            // get the photo
            cg_SitePhotos photo = db.cg_SitePhotos.Where(p => p.SitePhotoId == id).FirstOrDefault();

            // delete the file
            string filePath = Server.MapPath("~/content/site-photos/" + id + photo.FileExtension);
            if (System.IO.File.Exists(filePath)) System.IO.File.Delete(filePath);

            // delete the database record
            db.DeleteObject(photo);
            db.SaveChanges();
        }

        public void site_photo_delete_byParentId_fn(long parentId, string photoType)
        {
            // get the photos
            var photos = db.cg_SitePhotos.Where(p => p.ParentId == parentId);

            foreach (var photo in photos)
            {
                // delete the file
                string filePath = Server.MapPath("~/content/site-photos/" + photo.SitePhotoId + photo.FileExtension);
                if (System.IO.File.Exists(filePath)) System.IO.File.Delete(filePath);

                // delete the database record
                db.DeleteObject(photo);
            }

            // save changes to DB
            db.SaveChanges();
        }

        [HttpPost]
        public ActionResult site_photo_neworder(FormCollection collection)
        {
            long sitePhotoId = Convert.ToInt64(collection["SitePhotoId"]);
            int ListOrder = Convert.ToInt32(collection["ListOrder"]);
            long parentId = Convert.ToInt64(collection["ParentId"]);
            string photoType = collection["PhotoType"];

            // get the photo
            cg_SitePhotos photo = db.cg_SitePhotos.Where(p => p.SitePhotoId == sitePhotoId).FirstOrDefault();

            // update values
            photo.ListOrder = ListOrder;
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("site_photos", new { parentId = parentId, photoType = photoType });
        }

        [HttpPost]
        public ActionResult site_photo_newcaption(FormCollection collection)
        {
            long sitePhotoId = Convert.ToInt64(collection["SitePhotoId"]);
            long parentId = Convert.ToInt64(collection["ParentId"]);
            string photoType = collection["PhotoType"];
            string Description = collection["Description"];

            // get the photo
            cg_SitePhotos photo = db.cg_SitePhotos.Where(p => p.SitePhotoId == sitePhotoId).FirstOrDefault();

            // update values
            photo.Description = Description;
            db.SaveChanges();

            // redirect to list view
            return RedirectToAction("site_photos", new { parentId = parentId, photoType = photoType });
        }

        #endregion

        #region Slideshows

        public ActionResult slideshows()
        {
            var itemList = db.cg_Slideshows;
            return View(itemList);
        }

        public ActionResult slideshow(int id)
        {
            var item = db.cg_Slideshows.Where(s => s.SlideshowId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult slideshow_edit(int id)
        {
            var item = db.cg_Slideshows.Where(s => s.SlideshowId == id).FirstOrDefault();
            return View(item);
        }

        public ActionResult slideshow_delete(int id)
        {
            var item = db.cg_Slideshows.Where(s => s.SlideshowId == id).FirstOrDefault();

            site_photo_delete_byParentId_fn(id, "slideshow");

            db.DeleteObject(item);
            db.SaveChanges();
            return RedirectToAction("slideshows");
        }

        [HttpPost]
        public ActionResult slideshows_new(FormCollection collection)
        {
            var newItem = new cg_Slideshows();

            // add values
            newItem.SlideshowName = collection["SlideshowName"];
            newItem.SlideshowKey = collection["SlideshowKey"];
            newItem.LanguageCode = collection["LanguageCode"];

            // add to DB & save
            db.AddTocg_Slideshows(newItem);
            db.SaveChanges();

            return RedirectToAction("slideshows");
        }

        [HttpPost]
        public ActionResult slideshow_edit(FormCollection collection)
        {
            long SlideshowId = Convert.ToInt64(collection["SlideshowId"]);
            var item = db.cg_Slideshows.Where(s => s.SlideshowId == SlideshowId).FirstOrDefault();

            // add values
            item.SlideshowName = collection["SlideshowName"];
            item.SlideshowKey = collection["SlideshowKey"];
            item.LanguageCode = collection["LanguageCode"];

            // add to DB & save
            db.SaveChanges();

            return RedirectToAction("slideshows");
        }

        #endregion

        #region Files

        public string root = System.Configuration.ConfigurationManager.AppSettings["FilesManagementRoot"];
        public ActionResult files()
        {
            fileManageModel filesView = new fileManageModel();
            filesView.files = new List<FileInfo>();
            filesView.directories = new List<DirectoryInfo>();

            // select current directory
            string selectedDirectory = Request.QueryString["dir"];
            string selectedDirectoryPath = root;
            if (!String.IsNullOrEmpty(selectedDirectory))
                selectedDirectoryPath += selectedDirectory.TrimEnd('\\');

            // Enumerate files & directories
            DirectoryInfo di = new DirectoryInfo(Server.MapPath(selectedDirectoryPath));
            DirectoryInfo diRoot = new DirectoryInfo(Server.MapPath(root));

            filesView.currentDirectory = di;
            filesView.directories = di.GetDirectories().ToList();
            filesView.files = di.GetFiles().ToList();

            // Make the dropdown for directories
            filesView.directorySelectList = new List<SelectListItem>();

            // Get parent
            string parentPath = (di.Parent.FullName + "\\").Replace(diRoot.FullName, "");
            string currentRelativePath = (di.FullName.Replace(diRoot.FullName, "") + "\\");
            if (diRoot.FullName == di.FullName)
                parentPath = "";

            if (currentRelativePath == "\\")
                currentRelativePath = "";
            filesView.currentRelativePath = (root + currentRelativePath).Replace("~", "").Replace("\\\\", "/").Replace("\\", "/");

            // add a title inside the dropdown
            SelectListItem itemTitle = new SelectListItem { Text = "- select -", Value = "void" };
            filesView.directorySelectList.Add(itemTitle);

            // add a move up option
            if (diRoot.FullName != di.FullName)
            {
                SelectListItem moveUp = new SelectListItem();
                moveUp.Text = "<- move up";
                moveUp.Value = parentPath;
                filesView.directorySelectList.Add(moveUp);
            }

            foreach (var dirInfo in filesView.directories)
            {
                SelectListItem item = new SelectListItem();
                item.Text = currentRelativePath + dirInfo.Name;
                item.Value = currentRelativePath + dirInfo.Name.ToLower();
                item.Selected = selectedDirectory == item.Value ? true : false;

                filesView.directorySelectList.Add(item);
            }


            return View(filesView);
        }

        [HttpPost]
        public ActionResult files_new(FormCollection collection)
        {
            // select current directory
            string selectedDirectory = collection["dir"];
            string selectedDirectoryPath = root;
            if (!String.IsNullOrEmpty(selectedDirectory))
                selectedDirectoryPath += selectedDirectory.TrimEnd('\\');

            // Get file
            HttpPostedFileBase file = Request.Files["OriginalFileName"];

            if (file.ContentLength > 0)
            {
                string filePath = Path.Combine(Server.MapPath(selectedDirectoryPath), file.FileName);
                file.SaveAs(filePath);
            }

            return RedirectToAction("files", new { dir = selectedDirectory });
        }

        public ActionResult files_delete()
        {
            string filename = Request.QueryString["file"];
            string filePath = Server.MapPath(filename);
            string selectedDirectory = Request.QueryString["dir"];

            if (System.IO.File.Exists(filePath))
            {
                System.IO.File.Delete(filePath);
            }

            // redirect to list view
            return RedirectToAction("files", new { dir = selectedDirectory });
        }

        [HttpPost]
        public ActionResult directory_new(FormCollection collection)
        {
            // select current directory
            string selectedDirectory = collection["dir"];
            string selectedDirectoryPath = root;
            if (!String.IsNullOrEmpty(selectedDirectory))
                selectedDirectoryPath += selectedDirectory;

            string newDirName = collection["newDir"];

            // create the enw directory
            Directory.CreateDirectory(Server.MapPath(selectedDirectoryPath + "\\" + newDirName));

            return RedirectToAction("files", new { dir = selectedDirectory });
        }

        public ActionResult directory_delete()
        {

            string dirToDelete = Request.QueryString["deldir"];
            string dirToDeletePath = Server.MapPath(dirToDelete);
            string selectedDirectory = Request.QueryString["dir"];
            string selectedDirectoryPath = root;
            if (!String.IsNullOrEmpty(selectedDirectory))
                selectedDirectoryPath += selectedDirectory.TrimEnd('\\');

            // Enumerate files & directories
            DirectoryInfo di = new DirectoryInfo(Server.MapPath(selectedDirectoryPath));
            DirectoryInfo diRoot = new DirectoryInfo(Server.MapPath(root));

            // Get parent
            string parentPath = (di.Parent.FullName + "\\").Replace(diRoot.FullName, "");
            string currentRelativePath = (di.FullName.Replace(diRoot.FullName, "") + "\\");
            if (diRoot.FullName == di.FullName)
                parentPath = "";

            if (Directory.Exists(dirToDeletePath))
            {
                DeleteDirectory(dirToDeletePath);
            }

            // redirect to list view
            return RedirectToAction("files", new { dir = parentPath });
        }

        public static bool DeleteDirectory(string target_dir)
        {
            bool result = false;

            string[] files = Directory.GetFiles(target_dir);
            string[] dirs = Directory.GetDirectories(target_dir);

            foreach (string file in files)
            {
                System.IO.File.SetAttributes(file, FileAttributes.Normal);
                System.IO.File.Delete(file);
            }

            foreach (string dir in dirs)
            {
                DeleteDirectory(dir);
            }

            Directory.Delete(target_dir, false);

            return result;
        }




        #endregion


    }
}
