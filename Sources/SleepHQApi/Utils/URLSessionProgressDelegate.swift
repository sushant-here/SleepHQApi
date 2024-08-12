//
//  URLSessionProgressDelegate.swift
//  SleepHQApi
//
//  Created by Sushant Verma on 1/8/2024.
//

import Foundation

class URLSessionProgressDelegate: NSObject, URLSessionDataDelegate {
    private class Progress {
        var totalBytesExpectedToReceive: Int64 = 0
        var totalBytesReceived: Int64 = 0
    }

    private var uploadProgress: [Int: Progress] = [:]
    private func progress(for task: URLSessionTask) -> Progress {
        let taskIdentifier = task.taskIdentifier
        if let progress = uploadProgress[taskIdentifier] {
            return progress
        } else {
            let progress = Progress()
            uploadProgress[taskIdentifier] = progress
            return progress
        }
    }

    private func deleteProgress(for task: URLSessionTask) {
        let taskIdentifier = task.taskIdentifier
        uploadProgress.removeValue(forKey: taskIdentifier)
    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive response: URLResponse,
                    completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let progress = progress(for: dataTask)
            progress.totalBytesExpectedToReceive = response.expectedContentLength
        }
        completionHandler(.allow)
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didSendBodyData bytesSent: Int64,
                    totalBytesSent: Int64,
                    totalBytesExpectedToSend: Int64) {
        let percentage = Double(totalBytesSent) / Double(totalBytesExpectedToSend)
        print("Upload progress: \(percentage * 100)%")
    }

    func urlSession(_ session: URLSession,
                    dataTask: URLSessionDataTask,
                    didReceive data: Data) {
        let progress = progress(for: dataTask)
        progress.totalBytesReceived += Int64(data.count)
        let percent = Double(progress.totalBytesReceived) / Double(progress.totalBytesExpectedToReceive)
        print("Download Progress: \(percent * 100)%")
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: (any Error)?) {
        deleteProgress(for: task)
    }
}
