using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.Mvc;


public class utils
{

    public static bool ChangeUserName(string oldUserName, string newUserName)
    {
        bool IsSuccsessful = false;
        string ApplicationName;

        if (IsUserNameValid(newUserName))
        {
            if ((ConfigurationManager.ConnectionStrings["applicationName"] == null) || String.IsNullOrEmpty(ConfigurationManager.ConnectionStrings["applicationName"].ToString()))
            { ApplicationName = System.Web.Hosting.HostingEnvironment.ApplicationVirtualPath; }
            else
            { ApplicationName = ConfigurationManager.ConnectionStrings["applicationName"].ToString(); }

            SqlConnection myConn = new SqlConnection(ConfigurationManager.ConnectionStrings["ApplicationServices"].ToString());

            SqlCommand cmdChangeUserName = new SqlCommand();

            cmdChangeUserName.CommandText = "dbo.aspnet_Membership_ChangeUserName";
            cmdChangeUserName.CommandType = CommandType.StoredProcedure;
            cmdChangeUserName.Connection = myConn;
            cmdChangeUserName.Parameters.Add("@ApplicationName", SqlDbType.NVarChar);
            cmdChangeUserName.Parameters.Add("@OldUserName", SqlDbType.NVarChar);
            cmdChangeUserName.Parameters.Add("@NewUserName", SqlDbType.NVarChar);
            cmdChangeUserName.Parameters["@ApplicationName"].Value = ApplicationName;
            cmdChangeUserName.Parameters["@OldUserName"].Value = oldUserName;
            cmdChangeUserName.Parameters["@NewUserName"].Value = newUserName;

            try
            {
                myConn.Open();
                cmdChangeUserName.ExecuteNonQuery();
                myConn.Close();
                IsSuccsessful = true;
            }
            catch
            { IsSuccsessful = false; }
        }
        else { IsSuccsessful = false; }
        return IsSuccsessful;
    }

    private static bool IsUserNameValid(string username)
    {
        //Add whatever username requirement validation you want here, doesnt
        //the membership provider have some build in functionality for this?
        return true;
    }

}