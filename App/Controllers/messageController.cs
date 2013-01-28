using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Net.Mail;

namespace Caval_go.Controllers
{
    public class messageController : Controller
    {
        //
        // GET: /message/

        string[] hiddenList = "action,submit,subjectLine,redirectUrl,mailFrom,mailTo".Split(',');

        public ActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public void sendEmailForm(FormCollection collection)
        {
            // Set info
            string mailSubject = Request.Form["subjectLine"];
            string mailFrom = Request.Form["mailFrom"];
            string mailTo = Request.Form["mailTo"];

            int fieldCount = Request.Form.Count;
            string fieldTemplate = "<p style=\"font-family: Verdana, sans-serif;\"><strong>{0}:</strong> <br />{1}<br /></p>";
            string mailBody = "<h3 style=\"font-family: Verdana, sans-serif;\">" + mailSubject + "</h3>";
            for (int i = 0; i < fieldCount; i++)
            {
                string fieldName = Request.Form.Keys[i];
                if (!IsInList(fieldName, hiddenList))
                {
                    string fieldVal = Request.Form[i].Replace(Environment.NewLine, "<br />");
                    string fieldHtml = string.Format(fieldTemplate, fieldName, fieldVal);
                    mailBody += fieldHtml;
                }
            }

            try
            {
                // send the email
                SendEmail(mailBody, mailSubject, mailFrom, mailTo);
            }
            catch
            {
            }
            finally
            {
                // redirect after sending email
                string redirectUrl = Request.Form["redirectUrl"];
                Response.ContentType = "text/plain";
                Response.Write("success|email sent");
                if (!String.IsNullOrEmpty(redirectUrl))
                {
                    Response.Redirect(redirectUrl);
                }
            }
        }

        private void checkReferrer()
        {
            //For getting IP address of referrer server
            Uri referrerUri = Request.UrlReferrer;
            string strHostName = System.Net.Dns.GetHostName();
            System.Net.IPHostEntry ipHostInfo = System.Net.Dns.GetHostEntry(referrerUri.Host);
            System.Net.IPAddress ipAddress = ipHostInfo.AddressList[0];
            Response.Write("ipAddress: " + ipAddress.ToString() + "<br />referrer: " + referrerUri.Host);
        }

        private void SendEmail(string mailBody, string mailSubject, string mailFrom, string mailTo)
        {
            const string SERVER = "localhost";
            MailMessage oMail = new MailMessage();
            oMail.From = new MailAddress(mailFrom);
            oMail.To.Add(new MailAddress(mailTo));
            oMail.Subject = mailSubject;
            oMail.IsBodyHtml = true;
            oMail.Priority = MailPriority.High;
            oMail.Body = mailBody;
            SmtpClient smtp = new SmtpClient(SERVER);
            smtp.Send(oMail);
            oMail = null; // free up resources
        }

        #region Helpers

        private bool IsInList(string ItemToCheck, string[] Array)
        {
            foreach (string item in Array)
            {
                if (ItemToCheck.ToLower() == item.ToLower()) return true;
            }
            return false;
        }

        #endregion


    }
}
