using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.IO;

namespace Caval_go.Controllers
{
    public class imgController : Controller
    {

        #region Variables from QueryString

        int Height
        {
            get
            {
                return int.Parse(Request.QueryString["height"].ToString());
            }
        }

        int Width
        {
            get
            {
                return int.Parse(Request.QueryString["width"].ToString());
            }
        }

        string Path
        {
            get
            {
                return Request.QueryString["path"].ToString();
            }
        }

        #endregion

        #region Methods

        public void view()
        {
            string location = "";
            if (System.IO.File.Exists(Server.MapPath("~/" + Path)))
            {
                location = Server.MapPath("~/" + Path);
            }
            else
            {
                location = Server.MapPath("~/content/trip-photos/no-photo.png");
            }

            FileStream file = System.IO.File.Open(location, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            StreamReader streamR = new StreamReader(file);

            System.Drawing.Image imageF = System.Drawing.Image.FromStream(streamR.BaseStream);

            // Release the file
            file.Dispose();
            streamR.Dispose();

            // Set new width
            int oldWidth = imageF.Width;
            int oldHeight = imageF.Height;
            int newWidth = imageF.Width;
            int newHeight = imageF.Height;

            if (oldWidth > Width)
            {
                newWidth = Width;
            }

            // Set new height, preserve original width/height ratio
            newHeight = oldHeight * newWidth / oldWidth;

            if (newHeight > Height)
            {
                newHeight = Height;
                newWidth = oldWidth * newHeight / oldHeight;
            }

            Bitmap bmp = new Bitmap(newWidth, newHeight, PixelFormat.Format24bppRgb);

            bmp.SetResolution(imageF.HorizontalResolution, imageF.VerticalResolution);

            Graphics gph = Graphics.FromImage(bmp);
            gph.InterpolationMode = InterpolationMode.HighQualityBicubic;

            int sourceX = 0; int sourceY = 0;
            int destX = 0; int destY = 0;

            //Rectangle destRect = new Rectangle(destX - 1, destY - 1, newWidth + 2, newHeight + 2); //fix-hack for grey border problem
            Rectangle destRect = new Rectangle(destX - 1, destY - 1, newWidth + 2, newHeight + 2); //fix-hack for grey border problem
            Rectangle srcRect = new Rectangle(sourceX, sourceY, oldWidth, oldHeight);
            gph.DrawImage(imageF, destRect, srcRect, GraphicsUnit.Pixel);

            ImageCodecInfo[] codecs;
            codecs = ImageCodecInfo.GetImageEncoders();
            ImageCodecInfo iciInfo = null;
            int IntQuality = 80;
            foreach (ImageCodecInfo item in codecs)
            {
                if (item.MimeType == "image/jpeg")
                {
                    iciInfo = item;
                }
            }
            EncoderParameters ep = new EncoderParameters();
            ep.Param[0] = new EncoderParameter(Encoder.Quality, IntQuality);

            if (bmp.Equals(ImageFormat.Gif))
            {
                Response.ContentType = "image/gif";
            }
            else
            {
                Response.ContentType = "image/jpeg";
            }

            bmp.Save(Response.OutputStream, iciInfo, ep);

            imageF.Dispose();
            bmp.Dispose();
            gph.Dispose();
        }

        public bool ThumbnailCallback()
        {
            return true;
        }

        #endregion

    }
}
