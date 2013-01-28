using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Web.Mvc;

namespace Caval_go.Models
{
    #region Models

    public class ProductInfos_Language
    {
        public cg_Products_Info ProductInfo { get; set; }
        public cg_Languages Language { get; set; }

        public ProductInfos_Language()
        {
        }
    }

    public class ProductFullInfoByLanguage
    {
        public cg_Products Product { get; set; }
        public cg_Products_Info ProductInfo { get; set; }
        public cg_Languages Language { get; set; }
        public cg_Destinations_Info DestinationInfo { get; set; }
        public cg_Destinations Destination { get; set; }
        public IEnumerable<cg_Products_Dates> Dates { get; set; }
        public IEnumerable<cg_Products_Info_Tabs> Tabs { get; set; }
        public IEnumerable<cg_Activities_Info> Activities { get; set; }
        public IEnumerable<cg_Products_Photos> Photos { get; set; }
        public IEnumerable<ProductSearchResult> DestinationProducts { get; set; }
    }

    public class ProductFullInfo
    {
        public cg_Products Product { get; set; }
        public cg_Activities Activity { get; set; }
        public cg_Destinations Destination { get; set; }
        public IEnumerable<cg_Products_Dates> Dates { get; set; }
        public IEnumerable<cg_Products_Photos> Photos { get; set; }
    }

    public class ProductMessage
    {
        public string Title { get; set; }
        public string Description { get; set; }
    }

    public class ProductTagMap
    {
        public long ProductTagId { get; set; }
        public string Tag { get; set; }
        public bool TagSelect { get; set; }
        public cg_Products_Tags_Map TagMap { get; set; }
        public cg_Products_Tags_Info TagInfo { get; set; }
    }

    public class ProductSearchResult
    {
        public cg_Products Product { get; set; }
        public cg_Products_Info ProductInfo { get; set; }
        public cg_Products_Photos FirstPhoto { get; set; }
        public cg_Products_Dates FirstDate { get; set; }
        public cg_Products_Dates CheapestDate { get; set; }
        public cg_Destinations_Info Destination { get; set; }
        public IEnumerable<cg_Products_Tags_Map> TagsMap { get; set; }
        public IEnumerable<cg_Products_Activities_Map> ActivitiesMap { get; set; }
        public IEnumerable<cg_Activities> Activities { get; set; }
        public int Duration { get; set; }
        public cg_Languages Language { get; set; }
        public int AllYearRound { get; set; }
    }

    public class ProductSearchResultPage
    {
        public IEnumerable<ProductSearchResult> Products { get; set; }
        public IEnumerable<cg_Activities_Info> Activities { get; set; }
        public IEnumerable<cg_Activities_Info> Activities_All { get; set; }
        public IEnumerable<cg_Destinations_Info> Destinations { get; set; }
        public IEnumerable<cg_SitePhotos> SitePhotos { get; set; }
        public cg_Products_Tags_Info SelectedTagInfo { get; set; }
        public cg_Destinations_Info SelectedDestination { get; set; }
        public SearchEngineModel SearchEngineModel { get; set; }
    }

    public class ProductBookingPageInfo
    {
        public ProductFullInfoByLanguage ProductFullInfoLang { get; set; }
        public List<SelectListItem> DepartureDates { get; set; }
        public List<SelectListItem> ReturnDates { get; set; }
    }

    public class ProductBookingSubmission
    {
        // project
        public string SelectedDeparture { get; set; }
        public string SelectedReturn { get; set; }
        public int SelectedDateFlexibility { get; set; }
        public int AdultsCount { get; set; }
        public int ChildrenCount { get; set; }
        public int BedroomsCount { get; set; }
        public bool FlightSelected { get; set; }
        public string Comments { get; set; }

        // contact details
        public string LastName { get; set; }
        public string FirstName { get; set; }
        public string Adress { get; set; }
        public string ZipCode { get; set; }
        public string City { get; set; }
        public string Country { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string TimeToCall { get; set; }
        public string HowTheyFoundYou { get; set; }
        public bool NewsletterSignup { get; set; }
    }

    #endregion

    #region Service

    public class ProductService
    {
        caval_goEntities db = new caval_goEntities();

        public ProductFullInfoByLanguage getProductFullInfoByLanguage(long ProductId)
        {
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
            var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
            long defaultLanguageId = db.cg_Languages.Where(l => l.SystemLocale == defaultCulture).FirstOrDefault().LanguageId;

            /*
            var product = db.cg_Products.FirstOrDefault(p => p.ProductId == ProductId);
            var lang = db.cg_Languages.FirstOrDefault(l => l.SystemLocale.ToLower() == IetfLanguageTag.ToLower());
            var prodLangId = (product.cg_Products_Info.Where(prodinf => prodinf.LanguageId == lang.LanguageId).Count() > 0 ? lang.LanguageId : defaultLanguageId);
            var productInfo = product.cg_Products_Info.FirstOrDefault(i => i.LanguageId == (product.cg_Products_Info.Where(prodInfo => prodInfo.LanguageId == prodLangId).Count() > 0 ? prodLangId : defaultLanguageId));
            var prodActivityIds = product.cg_Products_Activities_Map.Select(am => am.cg_Activities.ActivityId);

            var prodFullInfo = new ProductFullInfoByLanguage
            {
                Product = product,
                Dates = product.cg_Products_Dates.OrderBy(d => d.DepartureDate),
                ProductInfo = productInfo,
                Photos = product.cg_Products_Photos.OrderBy(p => p.ListOrder),
                DestinationInfo = product.cg_Destinations.cg_Destinations_Info.FirstOrDefault(i => i.LanguageId == (product.cg_Destinations.cg_Destinations_Info.Where(d => d.LanguageId == prodLangId).Count() > 0 ? prodLangId : defaultLanguageId)),
                Destination = product.cg_Destinations,
                Tabs = productInfo.cg_Products_Info_Tabs.OrderBy(t => t.ListOrder),
                Language = lang,
                Activities = db.cg_Activities_Info.Where(ai => prodActivityIds.Contains(ai.ActivityId) && ai.LanguageId == (db.cg_Activities_Info.Where(aInfo => aInfo.LanguageId == prodLangId).Count() > 0 ? prodLangId : defaultLanguageId))
            };
            */

            var prodFullInfo = (from prods in db.cg_Products
                                where prods.ProductId == ProductId
                                from l in db.cg_Languages
                                where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                                from pi in prods.cg_Products_Info
                                where pi.LanguageId == (prods.cg_Products_Info.Where(prodinf => prodinf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                                from di in prods.cg_Destinations.cg_Destinations_Info
                                where di.LanguageId == (prods.cg_Destinations.cg_Destinations_Info.Where(d => d.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                                from am in prods.cg_Products_Activities_Map
                                select new ProductFullInfoByLanguage
                         {
                             Product = prods,
                             Dates = prods.cg_Products_Dates.OrderBy(d => d.DepartureDate),
                             ProductInfo = pi,
                             Photos = prods.cg_Products_Photos.OrderBy(p => p.ListOrder),
                             DestinationInfo = di,
                             Destination = prods.cg_Destinations,
                             Tabs = pi.cg_Products_Info_Tabs.OrderBy(t => t.ListOrder),
                             Language = l,
                             Activities = am.cg_Activities.cg_Activities_Info,//.Where(ai => ai.LanguageId == (am.cg_Activities.cg_Activities_Info.Where(aInfo => aInfo.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId))
                         }).FirstOrDefault();

            prodFullInfo.DestinationProducts = searchProducts(null, prodFullInfo.DestinationInfo.UrlCustomSegment.ToLower(), 0).Products;

            return prodFullInfo;
        }

        public ProductFullInfoByLanguage getEditProductFullInfoByLanguage(long ProductId, long LanguageId)
        {
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
            var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
            long defaultLanguageId = db.cg_Languages.Where(l => l.SystemLocale == defaultCulture).FirstOrDefault().LanguageId;

            var prodFullInfo = (from prods in db.cg_Products
                                where prods.ProductId == ProductId
                                from l in db.cg_Languages
                                where l.LanguageId == LanguageId
                                from pi in prods.cg_Products_Info
                                where pi.LanguageId == l.LanguageId
                                from am in prods.cg_Products_Activities_Map
                                select new ProductFullInfoByLanguage
                         {
                             Product = prods,
                             Dates = prods.cg_Products_Dates.OrderBy(d => d.DepartureDate),
                             ProductInfo = pi,
                             Photos = prods.cg_Products_Photos.OrderBy(p => p.ListOrder),
                             DestinationInfo = prods.cg_Destinations.cg_Destinations_Info.Where(di => di.LanguageId == l.LanguageId).FirstOrDefault(),
                             Destination = prods.cg_Destinations,
                             Tabs = pi.cg_Products_Info_Tabs.OrderBy(t => t.ListOrder),
                             Language = l,
                             Activities = am.cg_Activities.cg_Activities_Info.Where(ai => ai.LanguageId == l.LanguageId)
                         }).FirstOrDefault();

            return prodFullInfo;
        }

        public IQueryable<ProductSearchResult> searchProductItems()
        {
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
            var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
            long defaultLanguageId = db.cg_Languages.Where(l => l.SystemLocale == defaultCulture).FirstOrDefault().LanguageId;

            var items = from prods in db.cg_Products
                        where prods.cg_Products_Dates.Count() > 0 || prods.AllYearRound == true
                        from l in db.cg_Languages
                        where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                        from pi in prods.cg_Products_Info
                        where pi.LanguageId == (prods.cg_Products_Info.Where(prodinf => prodinf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                        select new ProductSearchResult
                        {
                            Product = prods,
                            AllYearRound = prods.AllYearRound == true ? 1 : 0,
                            FirstDate = prods.cg_Products_Dates.OrderBy(d => d.DepartureDate).FirstOrDefault(),
                            CheapestDate = prods.cg_Products_Dates.OrderBy(d => d.Price).FirstOrDefault(),
                            ProductInfo = pi,
                            FirstPhoto = prods.cg_Products_Photos.OrderBy(p => p.ListOrder).FirstOrDefault(),
                            Destination = prods.cg_Destinations.cg_Destinations_Info.Where(di => di.LanguageId == l.LanguageId).FirstOrDefault(),
                            TagsMap = prods.cg_Products_Tags_Map,
                            ActivitiesMap = prods.cg_Products_Activities_Map,
                            Language = l,
                            Duration = (int)prods.Duration
                        };
            return items;
        }


        public ProductSearchResultPage searchProducts(string tag, string destinationUrlCustomSegment, long activityId)
        {
            HttpRequest Request = HttpContext.Current.Request;
            HttpResponse Response = HttpContext.Current.Response;

            ProductSearchResultPage resultPage = new ProductSearchResultPage();
            string IetfLanguageTag = System.Threading.Thread.CurrentThread.CurrentCulture.IetfLanguageTag;
            var defaultCulture = ConfigurationManager.AppSettings["defaultLocale"];
            long defaultLanguageId = db.cg_Languages.FirstOrDefault(l => l.SystemLocale == defaultCulture).LanguageId;
            var language = db.cg_Languages.FirstOrDefault(l => l.SystemLocale.ToLower() == IetfLanguageTag.ToLower());
            var destinationInfo = new cg_Destinations_Info();
            List<string> excludedActivityStringIds = new List<string>();
            List<long> excludedActivityIds = new List<long>();

            string orderBy = "price";
            if (Request.QueryString["sort"] != null)
            {
                orderBy = Request.QueryString["sort"];
            }

            // filters
            string nameFilter = Request.QueryString["src_productName"];
            string codeFilter = Request.QueryString["src_productCode"];
            string tagFilter = tag;
            string budgetFilter = Request.QueryString["budget"];
            string departureFilter = Request.QueryString["dep"];

            // get the product results
            var items = searchProductItems();
            var AllItems = items;
            var AllItems_Tagged = items;

            if ((!String.IsNullOrEmpty(destinationUrlCustomSegment)) && (destinationUrlCustomSegment != "all"))
            {
                destinationInfo = db.cg_Destinations_Info.FirstOrDefault(di => (di.UrlCustomSegment.ToLower() == destinationUrlCustomSegment.ToLower() || di.Name.ToLower() == destinationUrlCustomSegment.ToLower()) && (di.LanguageId == language.LanguageId || di.LanguageId == defaultLanguageId));
                items = items.Where(p => p.Destination.UrlCustomSegment.ToLower() == destinationUrlCustomSegment.ToLower());
            }

            if (!String.IsNullOrEmpty(nameFilter))
            {
                items = items.Where(p => p.ProductInfo.Title.ToLower().Contains(nameFilter.ToLower()) == true);
            }

            if (!String.IsNullOrEmpty(codeFilter))
            {
                items = items.Where(p => p.Product.ProductCode.ToLower().Contains(codeFilter.ToLower()) == true);
            }

            if ((!String.IsNullOrEmpty(departureFilter)) && (departureFilter != "all"))
            {
                DateTime dfDeparture = Convert.ToDateTime(departureFilter);
                items = items.Where(p => p.Product.cg_Products_Dates.Where(dd => dd.DepartureDate.Year == dfDeparture.Year && dd.DepartureDate.Month == dfDeparture.Month).Count() > 0 || p.AllYearRound == 1);

                items = from prodResults in items
                        select new ProductSearchResult
                        {
                            Product = prodResults.Product,
                            AllYearRound = prodResults.AllYearRound,
                            FirstDate = prodResults.Product.cg_Products_Dates.Where(dd => dd.DepartureDate.Year == dfDeparture.Year && dd.DepartureDate.Month == dfDeparture.Month).OrderBy(d => d.DepartureDate).FirstOrDefault(),
                            CheapestDate = prodResults.Product.cg_Products_Dates.Where(dd => dd.DepartureDate.Year == dfDeparture.Year && dd.DepartureDate.Month == dfDeparture.Month).OrderBy(d => d.Price).FirstOrDefault(),
                            ProductInfo = prodResults.ProductInfo,
                            FirstPhoto = prodResults.FirstPhoto,
                            Destination = prodResults.Destination,
                            TagsMap = prodResults.TagsMap,
                            ActivitiesMap = prodResults.ActivitiesMap,
                            Language = prodResults.Language,
                            Duration = (int)prodResults.Duration
                        };
            }

            if ((!String.IsNullOrEmpty(budgetFilter)) && (budgetFilter != "all"))
            {
                Decimal iBudget = Convert.ToDecimal(budgetFilter);
                items = from p in items
                        where p.Product.cg_Products_Dates.Where(dd => dd.Price <= iBudget).Count() > 0 ||
                        (p.AllYearRound == 1 && p.Product.Price <= iBudget)
                        select p;
            }

            if ((!String.IsNullOrEmpty(tagFilter)) && (tagFilter != "all"))
            {
                List<string> tagFilterList = tag.Split(',').ToList();

                //cg_Products_Tags ptag = db.cg_Products_Tags.Where(t => t.Tag.ToLower() == tagFilter.ToLower()).FirstOrDefault();
                /*cg_Products_Tags ptag = (from ptags in db.cg_Products_Tags
                                         join tagFilterItem in tagFilterList on
                                         ptags.Tag.ToLower() equals tagFilterItem.ToLower()
                                         select ptags).FirstOrDefault();*/

                var ptags = from ptg in db.cg_Products_Tags.ToList()
                            join tagFilterItem in tagFilterList on
                            ptg.Tag.ToLower() equals tagFilterItem.ToLower()
                            select ptg;

                if (ptags.Count() > 0)
                {
                    foreach (var ptag in ptags)
                    {
                        var tid = ptag.ProductTagId;
                        items = items.Where(p => p.TagsMap.Where(tm => tm.cg_Products_Tags.ProductTagId == tid).Count() > 0);
                        AllItems_Tagged = AllItems.Where(p => p.TagsMap.Where(tm => tm.cg_Products_Tags.ProductTagId == tid).Count() > 0);
                        if ((ptag.EcludedCategories != null) && (ptag.EcludedCategories.Length > 0))
                        {
                            excludedActivityStringIds.AddRange(ptag.EcludedCategories.Split(','));
                        }
                    }

                    foreach (var excludedId in excludedActivityStringIds)
                    {
                        long aid = 0;
                        if (long.TryParse(excludedId, out aid))
                        {
                            excludedActivityIds.Add(aid);
                        }
                    }

                    long firstTagId = ptags.FirstOrDefault().ProductTagId;

                    resultPage.SelectedTagInfo = (from pt in db.cg_Products_Tags
                                                  where pt.ProductTagId == firstTagId
                                                  from pti in pt.cg_Products_Tags_Info
                                                  where pti.LanguageId == language.LanguageId
                                                  select pti).FirstOrDefault();
                }

            }

            if (activityId > 0)
            {
                cg_Activities activity = db.cg_Activities.Where(a => a.ActivityId == activityId).FirstOrDefault();
                if (activity != null)
                {
                    activity.cg_Products_Activities_Map.Load();
                    items = items.Where(p => p.ActivitiesMap.Where(am => am.cg_Activities.ActivityId == activity.ActivityId).Count() > 0);
                }
                else
                {
                    items = null;
                }
            }

            resultPage.Activities = (from prods in items
                                     from amaps in prods.ActivitiesMap
                                     from ai in amaps.cg_Activities.cg_Activities_Info
                                     where ai.LanguageId == (amaps.cg_Activities.cg_Activities_Info.Where(inf => inf.LanguageId == language.LanguageId).Count() > 0 ? language.LanguageId : defaultLanguageId)
                                     select ai).Distinct().OrderBy(a => a.Name).ToList().Where(a => !excludedActivityIds.Contains(a.ActivityId));

            resultPage.Activities_All = (from prods in AllItems_Tagged
                                         from amaps in prods.ActivitiesMap
                                         from ai in amaps.cg_Activities.cg_Activities_Info
                                         where ai.LanguageId == (amaps.cg_Activities.cg_Activities_Info.Where(inf => inf.LanguageId == language.LanguageId).Count() > 0 ? language.LanguageId : defaultLanguageId)
                                         select ai).Distinct().OrderBy(a => a.Name);
            /*
                                    (from a in db.cg_Activities
                                    from l in db.cg_Languages
                                    where l.SystemLocale.ToLower() == IetfLanguageTag.ToLower()
                                    from ai in a.cg_Activities_Info
                                    where ai.LanguageId == (a.cg_Activities_Info.Where(inf => inf.LanguageId == l.LanguageId).Count() > 0 ? l.LanguageId : defaultLanguageId)
                                    select ai).Distinct().OrderBy(a => a.Name);
            */

            resultPage.Destinations = (from d in db.cg_Destinations
                                       from di in d.cg_Destinations_Info
                                       where di.LanguageId == (d.cg_Destinations_Info.Where(inf => inf.LanguageId == language.LanguageId).Count() > 0 ? language.LanguageId : defaultLanguageId)
                                       select di).Distinct().OrderBy(d => d.Name);

            var photoType = "destination";
            long photoParentId = destinationInfo.DestinationId;

            /*
            try
            {
                if ((!String.IsNullOrEmpty(tagFilter)) && (tagFilter != "all"))
                {
                    photoType = "activity";
                    photoParentId = activityId;
                }
                else if (destinationInfo != null)
                {
                    photoType = "destination";
                    photoParentId = destinationInfo.DestinationId;
                }
            }
            catch { }
            */

            resultPage.SitePhotos = (from sp in db.cg_SitePhotos
                                     where sp.ParentId == photoParentId && sp.PhotoType == photoType
                                     select sp).OrderBy(sp => sp.ListOrder);
            if (orderBy == "date")
            {
                resultPage.Products = items.OrderByDescending(p => p.AllYearRound).ThenBy(p => p.FirstDate.DepartureDate);
            }
            else // by price
            {
                resultPage.Products = items.OrderBy(p => p.CheapestDate.Price).ThenBy(p => p.Product.AllYearRound == true);
            }

            resultPage.SelectedDestination = destinationInfo;

            return resultPage;
        }


        public ProductFullInfo getProductFullInfo(long ProductId)
        {
            var product = from prods in db.cg_Products
                          where prods.ProductId == ProductId
                          select new ProductFullInfo
                        {
                            Product = prods,
                            Dates = prods.cg_Products_Dates.OrderBy(d => d.DepartureDate),
                            Photos = prods.cg_Products_Photos.OrderBy(p => p.ListOrder),
                            //Activity = prods.cg_Activities,
                            Destination = prods.cg_Destinations
                        };

            return product.FirstOrDefault();
        }

    }

    #endregion
}