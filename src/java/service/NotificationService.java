package service;

import dao.NotificationsDAO;
import dao.PenggunaDAO;
import model.Notifications;
import java.util.List;

public class NotificationService {

    private static final NotificationsDAO notifDao = new NotificationsDAO();
    private static final PenggunaDAO pDao = new PenggunaDAO(); // After Phase 4 no-arg constructor

    /** Notify a single user */
    public static void notifyUser(int idPengguna, String jenis, String tajuk, String mesej, String pautan) {
        try {
            Notifications n = build(jenis, tajuk, mesej, pautan);
            n.setId_pengguna(idPengguna);
            notifDao.insertNotifications(n);
        } catch (Exception e) { e.printStackTrace(); }
    }

    /** Notify all AJK in a specific biro */
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

    /** Notify all users with a specific role */
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

    /** Broadcast to all active users (excluding sender) */
    public static void broadcast(int excludeUserId, String jenis, String tajuk, String mesej, String pautan) {
        try {
            List<Integer> ids = pDao.getAllActiveIds();
            ids.removeIf(uid -> uid == excludeUserId);
            notifDao.insertBatch(ids, jenis, tajuk, mesej, pautan);
        } catch (Exception e) { e.printStackTrace(); }
    }

    private static Notifications build(String jenis, String tajuk, String mesej, String pautan) {
        Notifications n = new Notifications();
        n.setJenis(jenis);
        n.setTajuk(tajuk);
        n.setMesej(mesej);
        n.setPautan(pautan);
        return n;
    }
}
