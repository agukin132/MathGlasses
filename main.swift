import SwiftUI
import UserNotifications

// Это твой "мозг" приложения
class MathSolver: ObservableObject {
    func solveMathProblem(imageData: Data) {
        // 1. Отправляем фото в Gemini (упрощённый пример)
        let apiKey = "ТВОЙ_КЛЮЧ_GEMINI"
        let url = URL(string: "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=\(apiKey)")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let base64 = imageData.base64EncodedString()
        let body: [String: Any] = [
            "contents": [["parts": [
                ["text": "Реши задачу на фото и дай краткий ответ."],
                ["inline_data": ["mime_type": "image/jpeg", "data": base64]]
            ]]]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data, let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                // 2. Отправляем ответ на часы через уведомление
                self.showNotification(answer: "Ответ получен!") // Тут парсинг реального ответа
            }
        }.resume()
    }
    
    func showNotification(answer: String) {
        let content = UNMutableNotificationContent()
        content.title = "Ответ от ИИ"
        content.body = answer
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
}

// Простое окно для теста
struct ContentView: View {
    @StateObject var solver = MathSolver()
    
    var body: some View {
        VStack {
            Text("Math Glasses App")
            Button("Симулировать фото") {
                // Тут в реальности будет вызов камеры очков
                solver.showNotification(answer: "Тестовый ответ")
            }
        }
    }
}
