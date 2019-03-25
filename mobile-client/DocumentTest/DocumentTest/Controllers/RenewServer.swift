public struct GetFilesResponse : Codable
{
    var result: Bool
    var files: [filedetails]
}

extension GetFilesResponse
{
    init()
    {
        self.result = false
        self.files = [filedetails.init()]
    }
}

public struct filedetails: Codable
{
    var file_name: String
    var version: Int
    var locked: Bool
    var file_id: String
    var url: URL
    // let url: Foundation.URL = URL()
}

extension filedetails
{
    init()
    {
        self.file_name = ""
        self.version = 0
        self.locked = false
        self.file_id = ""
        let temp = "https://www.apple.com"
        self.url = URL(string: temp)!
    }
}

public var user=GetFilesResponse.init()

public class UpdateServerFiles
{
    public func UpdateFile ()
    {
        let url = "http://52.151.113.157/get_all_file_details"
        let urlObj = URL(string: url)
        URLSession.shared.dataTask(with: urlObj!)
        {
            (data, response, error)in
            do{
                print(data, response);
                user = try JSONDecoder().decode(GetFilesResponse.self, from: data!)
                for i in user.files
                {
                    print (i.file_name)
                    //self.labels.text=i.file_name
                }
                print ("SUCCESS")
            }catch
            {
                print("ERROR")
            }
            }.resume()
    }
}
