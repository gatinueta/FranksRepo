package ch.post.pv.counter.client.ui.widgets.pdfviewer;

import java.awt.image.BufferedImage;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.swt.graphics.ImageData;
import org.eclipse.swt.graphics.Point;
import org.jpedal.PdfDecoder;
import org.jpedal.exception.PdfException;

import ch.post.pv.counter.client.core.Counter;
import ch.post.pv.counter.client.core.CounterJob;
import ch.post.pv.counter.client.ui.util.ImageHelper;
import ch.post.pv.counter.client.ui.widgets.IPDFViewerAdapter;
import ch.post.pv.counter.client.ui.widgets.internal.AbstractFocusableWidgetAdapter;
import ch.post.pv.counter.shared.core.cache.ICache;

/**
 * Adapter for an image viewer.<br>
 * It maintains a cache of pages that are shown or might be shown in future to decrease loading time when the user wants to change
 * the page. Therefore, a concurrent job is started that fills the cache with the next pages is started after opening a PDF. Furthermore,
 * after changing the page, it is tried to  prefetch the next page (in the change direction).
 * @author wueestf
 */
public class PDFViewerAdapter extends AbstractFocusableWidgetAdapter implements IPDFViewerAdapter {
    
    /**
     * Classed used for passing the needed values to the UI 
     * @author wueestf
     */
    static class PDFContent {
        public PDFContent(ImageData imageData, int currentPage, int pageCount) {
            this.imageData = imageData;
            this.currentPage = currentPage;
            this.pageCount = pageCount;
        }
        int currentPage;
        int pageCount;
        ImageData imageData;
    }
    
    /**
     * Job to load pages in the background
     * @author wueestf
     */
    private class BackgroundLoadPagesJob extends CounterJob {

        private Object lock = new Object();
        private boolean canceled = false;
        private int startPage;
        private int endPage;
        
        public BackgroundLoadPagesJob(int startPage, int endPage) {
            super("PDFViewer.BackgroundLoadPagesJob");
            this.startPage = startPage;
            this.endPage = endPage;
        }

        @Override
        protected void runWithException(IProgressMonitor monitor) {
            for (int pageToLoad = startPage; pageToLoad <= endPage; pageToLoad++) {

                synchronized (lock) {
                    // load the pages as long as the job is not canceled
                    if (canceled) {
                        if (logger.isDebugEnabled()) { logger.debug("job " + getName() + " was canceled, return."); }
                        return;
                    }
                    loadPage(pageToLoad);
                }
                
                // yield the job and don't consume to much time at once
                Thread.yield();
            }
        }
        
        @Override
        protected void canceling() {
            synchronized (lock) {
                canceled = true;
                if (logger.isDebugEnabled()) { logger.debug("job " + getName() + " canceled"); }
            }
            super.canceling();
        }
    }
    
    public static final String PROP_PDF_CONTENT = "pdfContent";
    private static final int IMAGE_DATA_CACHE_SIZE = 5;
    private static final Logger logger = Logger.getLogger(PDFViewerAdapter.class);
    
    private CounterJob backgroundLoadPagesJob;
    private int pageCount = 0;
    private int currentPage = 0;
    private ImageData pdfData = null;
    private float zoomFactor = 1.0f;
    private Point currentSize = new Point(0, 0);
    // WARNING: The LRUCache implementation is not thread-safe. Ensure access in thread-safe way in this class.
    private ICache<Integer, ImageData> imageDataCache = Counter.getCacheMaster().createLRUCache("pdfImageCache", IMAGE_DATA_CACHE_SIZE);
    
    public PDFViewerAdapter(String name, String fileName) {
        super(name);
        if (fileName != null) {
            _openPDFFile(fileName);
        }
    }
    
    public PDFViewerAdapter(String name, byte[] pdfArray) {
        super(name);
        if (pdfArray != null) {
            _openPDFArray(pdfArray);
        }
    }

    @Override
    public boolean openPDFFile(String fileName) {
        boolean fileOpend = _openPDFFile(fileName);
        loadPagesInBackground();
        return fileOpend;
    }
    
    @Override
    public boolean openPDFArray(byte[] pdfArray) {
        boolean fileOpend = _openPDFArray(pdfArray);
        loadPagesInBackground();
        return fileOpend;
    }
    
    /**
     * Internal method to open file, but does not start loading the pages in background.
     */
    private boolean _openPDFFile(String fileName) {
        try {
            cancelJobClosePDF();
            pdfDecoder.openPdfFile(fileName);
            afterOpenPDF();
        } catch (PdfException e) {
            logger.warn("Exception caught while opening PDF file: ", e);
            return false;
        }
        return true;
    }
    
    /**
     * Internal method to open file, but does not start loading the pages in background.
     */
    private boolean _openPDFArray(byte[] pdfArray) {
        try {
            cancelJobClosePDF();
            pdfDecoder.openPdfArray(pdfArray);
            afterOpenPDF();
        } catch (PdfException e) {
            logger.warn("Exception caught while opening PDF array: ", e);
            return false;
        }
        return true;
    }
    
    private void cancelJobClosePDF() {
        if (backgroundLoadPagesJob != null) {
            backgroundLoadPagesJob.cancel();
        }
        pdfDecoder.closePdfFile();
        clearImageDataCache();
    }
    
    private void afterOpenPDF() {
        pageCount = pdfDecoder.getPageCount();
        currentPage = 0;
        // the method getPDFWidth depends on the page parameters (zoom factor) so set the zoom factor to 1.0 before 
        // calculating the new one
        pdfDecoder.setPageParameters(1.0f, 1);

        zoomFactor = (float) currentSize.x / (float) pdfDecoder.getPDFWidth();
        showPage(1);
    }

    @Override
    public boolean nextPage() {
        return changePage(currentPage + 1, 1);
    }
    
    @Override
    public boolean previousPage() {
        return changePage(currentPage - 1, -1);
    }

    @Override
    public boolean firstPage() {
        return changePage(1, 1);
    }

    @Override
    public boolean lastPage() {
        return changePage(pageCount, -1);
    }
    
    /**
     * Change the page to page and prefetch the next page in the passed direction
     * @param page the page to show
     * @param direction the direction for the page to prefetch
     * @return
     */
    private boolean changePage(int page, int direction) {
        boolean pageShown = false;
        if (isPageValid(page)) {
            pageShown = showPage(page);
            int nextPage = page + direction;
            if (isPageValid(nextPage)) {
                loadImagesInBackground(nextPage, nextPage);
            }
        }
        return pageShown;
    }
    
    private boolean isPageValid(int page) {
        return page > 0 && page <= pageCount;
    }
    
    private synchronized boolean showPage(int page) {
        if (logger.isDebugEnabled()) { logger.debug("Show page " + page); }
        if (currentPage == page) {
            if (logger.isDebugEnabled()) { logger.debug("Page already shown. Abort"); }
            return true;
        }
        if (!imageDataCache.isCached(page)) {
            loadPage(page);
        }
        currentPage = page;
        if (imageDataCache.isCached(page)) {
            pdfData =  imageDataCache.getCache(page);
            support.firePropertyChange(PROP_PDF_CONTENT, null, new PDFContent(pdfData, currentPage, pageCount));
            return true;
        } else {
            return false;
        }
    }
    
    interface ExternalPDFDecoder {

		BufferedImage getPageAsImage(float zoomFactor, int page)
				throws PdfException;

		int getPDFWidth();

		void setPageParameters(float f, int i);

		void openPdfFile(String fileName) throws PdfException;

		void openPdfArray(byte[] pdfArray) throws PdfException;

		void closePdfFile();

		int getPageCount();
    	
    }
    
    static class JPedalPDFDecoder implements ExternalPDFDecoder {
        private PdfDecoder decodePDF = new PdfDecoder();

        @Override
    	public BufferedImage getPageAsImage(float zoomFactor, int page) throws PdfException {
    		decodePDF.setPageParameters(zoomFactor, page);
            return decodePDF.getPageAsImage(page);
    	}

        @Override
		public int getPageCount() {
			return decodePDF.getPageCount();
		}

        @Override
		public void closePdfFile() {
	        if (decodePDF.isOpen()) {
	            decodePDF.closePdfFile();
	        }
		}

        @Override
		public void openPdfArray(byte[] pdfArray) throws PdfException {
            decodePDF.openPdfArray(pdfArray);
		}

        @Override
		public void openPdfFile(String fileName) throws PdfException {
            decodePDF.openPdfFile(fileName);
		}

        @Override
		public void setPageParameters(float f, int i) {
	        decodePDF.setPageParameters(1.0f, 1);
		}
        @Override
		public int getPDFWidth() {
			return decodePDF.getPDFWidth();
		}
    }
    
    private JPedalPDFDecoder pdfDecoder = new JPedalPDFDecoder();
    
    private synchronized void loadPage(int page) {
        if (logger.isDebugEnabled()) { logger.debug("Loading page: " + page); }
        if (!isPageValid(page)) {
            if (logger.isDebugEnabled()) { logger.debug("Cannot load page. Inavid page number: " + page); }
            return;
        }
        if (imageDataCache.isCached(page)) {
            if (logger.isDebugEnabled()) { logger.debug("Cache already contains page: " + page); }
            return;
        }
        ImageData imageData;
        try {
        	BufferedImage bi = pdfDecoder.getPageAsImage(zoomFactor, page);
            imageData =  ImageHelper.convertToSWT(bi);
            imageDataCache.putCache(page, imageData);
        } catch (PdfException e) {
            if (logger.isDebugEnabled()) { logger.debug("Cannot load page. Exception caught. ", e); }
        }
    }
    
    private synchronized void clearImageDataCache() {
        imageDataCache.clearCache();
    }
    
    private void loadImagesInBackground(int startPage, int endPage) {
        if (backgroundLoadPagesJob != null) {
            backgroundLoadPagesJob.cancel();
        }
        backgroundLoadPagesJob = new BackgroundLoadPagesJob(startPage, endPage);
        Counter.getUIMediator().runJobConcurrently(backgroundLoadPagesJob);
    }
    
    private void loadPagesInBackground() {
        loadImagesInBackground(2, Math.min(IMAGE_DATA_CACHE_SIZE, pageCount));
    }
    
    void controlResized(Point newSize) {
        currentSize = newSize;
        // the PDF should fill the complete space. So update the zoom factor when the widget is resized
        // and show the page again.
        zoomFactor = (float) newSize.x / (float) pdfDecoder.getPDFWidth();
        clearImageDataCache();
        currentPage = 0;
        showPage(1);
        loadPagesInBackground();
    }
    
    PDFContent getPDFContent() {
        return new PDFContent(pdfData, currentPage, pageCount);
    }
    
    @Override
    public void uiWidgetDisposed() {
        if (logger.isDebugEnabled()) { logger.debug("uiWidgetDisposed() called"); }
        cancelJobClosePDF();
    }
   
    @Override
    public void clear() {
        if (logger.isDebugEnabled()) { logger.debug("clear() called"); }
        pageCount = 0;
        currentPage = 0;
        cancelJobClosePDF();
        support.firePropertyChange(PROP_PDF_CONTENT, null, new PDFContent(null, 0, 0));
    }
}
