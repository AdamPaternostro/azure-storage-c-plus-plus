#include <was/storage_account.h>
#include <was/blob.h>
#include <cpprest/filestream.h>  
#include <cpprest/containerstream.h>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

// Define the connection-string with your values.
const utility::string_t storage_connection_string(U("DefaultEndpointsProtocol=https;AccountName=<<REMOVED>>;AccountKey=<<REMOVED>>;EndpointSuffix=core.windows.net"));

int main(int argc, char *argv[])
{
    // Retrieve storage account from connection string.
    azure::storage::cloud_storage_account storage_account = azure::storage::cloud_storage_account::parse(storage_connection_string);

    // Create the blob client.
    azure::storage::cloud_blob_client blob_client = storage_account.create_cloud_blob_client();

    // Retrieve a reference to a previously created container.
    azure::storage::cloud_blob_container container = blob_client.get_container_reference(U("my-sample-container"));

    // Retrieve reference to a blob named "my-blob-2".
    azure::storage::cloud_block_blob blockBlob = container.get_block_blob_reference(U("my-blob-2"));

    // Save blob contents to a file.
    concurrency::streams::container_buffer<std::vector<uint8_t>> buffer;
    concurrency::streams::ostream output_stream(buffer);
    blockBlob.download_to_stream(output_stream);

    std::ofstream outfile("DownloadBlobFile.txt", std::ofstream::binary);
    std::vector<unsigned char>& data = buffer.collection();

    outfile.write((char *)&data[0], buffer.size());
    outfile.close();  

    concurrency::streams::container_buffer<std::vector<uint8_t>> bufferTwo;

    // read as stream and display
    string       stmp;
    stringstream sstmp;
    concurrency::streams::istream bstream = blockBlob.open_read();
    if (bstream.is_open())
    {
        cout << "Stream is open" << endl;
        cout.flush();
    }
    bstream.read_to_end(bufferTwo).get();
    bstream.close();
    cout << "Stream is closed" << endl;

    std::string s(bufferTwo.collection().begin(), bufferTwo.collection().end());
    cout << s << endl;
}