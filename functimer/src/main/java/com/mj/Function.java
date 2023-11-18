package com.mj;

import com.azure.core.credential.TokenCredential;
import com.azure.core.util.BinaryData;
import com.azure.identity.DefaultAzureCredentialBuilder;
import com.azure.identity.ManagedIdentityCredential;
import com.azure.identity.ManagedIdentityCredentialBuilder;
import com.azure.storage.blob.BlobClient;
import com.azure.storage.blob.BlobContainerClient;
import com.azure.storage.blob.BlobServiceClient;
import com.azure.storage.blob.BlobServiceClientBuilder;
import com.microsoft.azure.functions.ExecutionContext;
import com.microsoft.azure.functions.HttpMethod;
import com.microsoft.azure.functions.HttpRequestMessage;
import com.microsoft.azure.functions.HttpResponseMessage;
import com.microsoft.azure.functions.HttpStatus;
import com.microsoft.azure.functions.annotation.AuthorizationLevel;
import com.microsoft.azure.functions.annotation.FunctionName;
import com.microsoft.azure.functions.annotation.HttpTrigger;
import com.microsoft.azure.functions.annotation.TimerTrigger;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.util.Date;
import java.util.Optional;

/**
 * Azure Functions with HTTP Trigger.
 */
public class Function {

    @FunctionName("keepAlive")
    public void keepAlive(
            @TimerTrigger(name = "keepAliveTrigger", schedule = "* * * * * *") String timerInfo,
            ExecutionContext context) throws ParseException {
        // timeInfo is a JSON string, you can deserialize it to an object using your
        // favorite JSON library

        Timestamp ts = new Timestamp(new Date().getTime());
        SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        Date date = format.parse(ts.toString());
        format = new SimpleDateFormat("dd-MM-yyyy-HH-mm");

        String connectStr = System.getenv("AzureWebJobsStorage");
        String accountName = System.getenv("AzureWebJobsStorage__accountname");

        context.getLogger().info("connectStrww is triggered: " + connectStr);

        // BlobServiceClient blobServiceClient = new
        // BlobServiceClientBuilder().connectionString(connectStr)
        // .buildClient();
        TokenCredential credential = new ManagedIdentityCredentialBuilder().build();
        BlobServiceClient blobServiceClient = new BlobServiceClientBuilder()
                .endpoint("https://" + accountName + ".blob.core.windows.net/")
                .credential(credential)
                .buildClient();
        BlobContainerClient xmlContainer = blobServiceClient.getBlobContainerClient("timecontainer");
        BlobClient blobClient = xmlContainer.getBlobClient(format.format(date) + ".txt");
        blobClient.upload(BinaryData.fromString("Azure Function wwww" + connectStr));

        context.getLogger().info("Timer is triggered: " + timerInfo);
    }
}
