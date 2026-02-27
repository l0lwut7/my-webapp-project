import com.example.todo.Task;
import com.example.todo.TaskDAO;
import java.util.List;

public class TestDao {
    public static void main(String[] args) {
        TaskDAO dao = new TaskDAO();
        System.out.println("Initial list:");
        for(Task t : dao.findAll()) {
            System.out.println(t);
        }
        Task t1 = dao.create(new Task("Test insert 1", false));
        System.out.println("Created ID: " + t1.getId());
        
        System.out.println("List after insert:");
        for(Task t : dao.findAll()) {
            System.out.println(t);
        }
    }
}
