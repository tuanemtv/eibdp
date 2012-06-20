package test.org.eib.xml;

import java.util.ListIterator;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.Namespace;
import org.dom4j.QName;
import org.dom4j.Visitor;
import org.dom4j.VisitorSupport;
import org.dom4j.io.SAXReader;


public class VisitorExample {
	public static void main(String[] args) throws Exception {
	    Document doc = new SAXReader().read("person.xml");
	    Namespace oldNs = Namespace.get("oldNamespace");
	    Namespace newNs = Namespace.get("newPrefix", "newNamespace");
	    Visitor visitor = new NamesapceChangingVisitor(oldNs, newNs);
	    doc.accept(visitor);
	    System.out.println(doc.asXML());
	  }
	}

	class NamesapceChangingVisitor extends VisitorSupport {
	  private Namespace from;
	  private Namespace to;

	  public NamesapceChangingVisitor(Namespace from, Namespace to) {
	    this.from = from;
	    this.to = to;
	  }

	  public void visit(Element node) {
	    Namespace ns = node.getNamespace();

	    if (ns.getURI().equals(from.getURI())) {
	      QName newQName = new QName(node.getName(), to);
	      node.setQName(newQName);
	    }

	    ListIterator namespaces = node.additionalNamespaces().listIterator();
	    while (namespaces.hasNext()) {
	      Namespace additionalNamespace = (Namespace) namespaces.next();
	      if (additionalNamespace.getURI().equals(from.getURI())) {
	        namespaces.remove();
	      }
	    }
	  }
}
