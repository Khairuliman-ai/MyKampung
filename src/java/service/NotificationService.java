package service;

import dao.NotificationsDAO;
import dao.PenggunaDAO;
import model.Notifications;
import java.util.List;

/**
 * NotificationService handles business logic for dispatching user notifications.
 * Implements various distribution strategies including single user targeting, role-based targeting,
 * biro/committee targeting, and global system broadcasts.
 */
public class NotificationService {

    private static final NotificationsDAO notifDao = new NotificationsDAO();
    private static final PenggunaDAO pDao = new PenggunaDAO();

    /**
     * Sends a notification to a single user.
     * 
     * @param idPengguna the target user ID
     * @param jenis the type category of the notification
     * @param tajuk the title of the notification
     * @param mesej the body text of the notification
     * @param pautan the URL path or page mapping to redirect the user when clicked
     */
    public static void notifyUser(int idPengguna, String jenis, String tajuk, String mesej, String pautan) {
        try {
            Notifications n = build(jenis, tajuk, mesej, pautan);
            n.setId_pengguna(idPengguna);
            notifDao.insertNotifications(n);
        } catch (Exception e) { e.printStackTrace(); }
    }

    /**
     * Sends a notification to all AJK (committee) members assigned to a specific biro.
     * 
     * @param namaJawatan the name of the biro (e.g. Biro Keselamatan, Biro Kebajikan)
     * @param jenis the type category of the notification
     * @param tajuk the title of the notification
     * @param mesej the body text of the notification
     * @param pautan the redirection URL
     */
    public static void notifyByJawatan(String namaJawatan, String jenis, String tajuk, String mesej, String pautan) {
        try {
            List<Integer> ids = pDao.getIdsByJawatan(namaJawatan);
            Notifications n = build(jenis, tajuk, mesej, pautan);
            for (int id : ids) {
                n.setId_pengguna(id);
                notifDao.insertNotifications(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    /**
     * Sends a notification to all users holding a specific role.
     * 
     * @param namaPeranan the role name (e.g. Ketua Kampung, Setiausaha, Penduduk)
     * @param jenis the type category of the notification
     * @param tajuk the title of the notification
     * @param mesej the body text of the notification
     * @param pautan the redirection URL
     */
    public static void notifyByPeranan(String namaPeranan, String jenis, String tajuk, String mesej, String pautan) {
        try {
            List<Integer> ids = pDao.getIdsByPeranan(namaPeranan);
            Notifications n = build(jenis, tajuk, mesej, pautan);
            for (int id : ids) {
                n.setId_pengguna(id);
                notifDao.insertNotifications(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    /**
     * Broadcasts a notification to all active users in the system, excluding the specified user.
     * Uses batch database execution for performance efficiency.
     * 
     * @param excludeUserId the user ID to exclude from the broadcast (e.g. the publisher)
     * @param jenis the type category of the notification
     * @param tajuk the title of the notification
     * @param mesej the body text of the notification
     * @param pautan the redirection URL
     */
    public static void broadcast(int excludeUserId, String jenis, String tajuk, String mesej, String pautan) {
        try {
            List<Integer> ids = pDao.getAllActiveIds();
            ids.removeIf(uid -> uid == excludeUserId);
            notifDao.insertBatch(ids, jenis, tajuk, mesej, pautan);
        } catch (Exception e) { e.printStackTrace(); }
    }

    /**
     * Private helper to build a Notifications domain model object.
     */
    private static Notifications build(String jenis, String tajuk, String mesej, String pautan) {
        Notifications n = new Notifications();
        n.setJenis(jenis);
        n.setTajuk(tajuk);
        n.setMesej(mesej);
        n.setPautan(pautan);
        return n;
    }
}
