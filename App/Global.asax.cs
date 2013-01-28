using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.Mvc;
using System.Web.Routing;

namespace NextDayOrderApp
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                "Root",
                "{action}",
                new { controller = "Root", action = "Index" },
                new { IsRootAction = new IsRootActionConstraint() }  // Route Constraint
            );

            routes.MapRoute(
                "cms",
                "cms/{keyname}",
                new { controller = "cms", action = "index", keyname = "" }
            );

            routes.MapRoute(
                "destination",
                "destination/{keyname}",
                new { controller = "root", action = "destination", keyname = "" }
            );

            routes.MapRoute(
                "voyage",
                "voyage/search/{tag}/{destination}",
                new { controller = "voyage", action = "search", tag = "", destination = "" }
            );

            routes.MapRoute(
                "voyage destinations",
                "voyage/destinations/{destination}/{activityId}",
                new { controller = "voyage", action = "destinations", destination = "", activityId = "" }
            );

            routes.MapRoute(
                "voyage detail",
                "voyage/detail/{id}/{keyword}",
                new { controller = "voyage", action = "detail", id = 0, keyword = "" }
            );

            routes.MapRoute(
                "site photos",
                "manage/site_photos/{parentId}/{photoType}",
                new { controller = "manage", action = "site_photos", parentId = 0, photoType = "" }
            );

            routes.MapRoute(
                "Default", // Route name
                "{controller}/{action}/{id}", // URL with parameters
                new { controller = "Home", action = "Index", id = UrlParameter.Optional } // Parameter defaults
            );

        }

        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RegisterRoutes(RouteTable.Routes);
        }

        protected void Application_BeginRequest()
        {
            loadCulture();
            checkDomainName();
        }

        protected void Application_AuthenticateRequest()
        {
            if (User != null)
                Membership.GetUser(true);
        }

        private void loadCulture()
        {
            string Lang = null;
            string newLang = Request.QueryString["lg"];

            if (Request.ServerVariables["HTTP_HOST"] == "en.cavalandgo.com")
            {
                newLang = "en-GB";
            }
            else if (Request.ServerVariables["HTTP_HOST"] == "es.cavalandgo.com")
            {
                newLang = "es-ES";
            }
            else
            {
                newLang = "fr-FR";
            }

            HttpCookie cultureCookie = Request.Cookies["culture"];

            if ((cultureCookie != null) && (newLang == null))
            {
                Lang = cultureCookie.Value;
                cultureCookie.Expires = DateTime.Now.AddMonths(1);
            }
            else if (newLang != null)
            {
                Lang = newLang;
                if (cultureCookie == null)
                {
                    cultureCookie = new HttpCookie("culture", Lang);
                }
                else
                {
                    cultureCookie.Value = Lang;
                }
                cultureCookie.Expires = DateTime.Now.AddMonths(1);
                Response.Cookies.Add(cultureCookie);
            }

            if (Lang != null)
            {
                if (Lang.Length < 3)
                    Lang = Lang + "-" + Lang.ToUpper();
                try
                {
                    System.Threading.Thread.CurrentThread.CurrentCulture =
                                       new System.Globalization.CultureInfo(Lang);
                    if (cultureCookie == null)
                    {
                        cultureCookie = new HttpCookie("culture", Lang);
                        cultureCookie.Expires = DateTime.Now.AddMonths(1);
                        Response.Cookies.Add(cultureCookie);
                    }
                }
                catch
                { ;}
            }
            else
            {

            }
        }

        private void checkDomainName()
        {
            string goodDomain = "www.cavalandgo.com";
            string badDomain = "cavalandgo.com";
            if (Request.ServerVariables["HTTP_HOST"] == badDomain)
            {
                Response.Status = "301 Moved Permanently";
                Response.AddHeader("Location", "http://" + goodDomain + Request.ServerVariables["PATH_INFO"]);

                if ((Request.QueryString.Count >= 1) && (Request.ServerVariables["HTTP_HOST"] == badDomain))
                {
                    Response.Status = "301 Moved Permanently";
                    Response.AddHeader("Location", "http://" + goodDomain + Request.ServerVariables["PATH_INFO"] + "?" + Request.QueryString.ToString());
                }
            }
        }

    }
}