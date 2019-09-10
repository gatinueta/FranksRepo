#include <memory>
#include <iostream>

enum TravType {
    Prefix,
    Postfix,
    Infix
};

struct Node {
    Node(std::string data) : m_data(data) {
    }
    Node(const Node& node) : m_data(node.m_data) {
    }
    const std::string& data() const {
        return m_data;
    }
    void insert(const std::string& s) {
        if (m_data.compare(s) >= 0) {
            if (left) {
                left->insert(s);
            } else {
                left = std::make_unique<Node>(s);
            }
        } else {
            if (right) {
                right->insert(s);
            } else {
                right = std::make_unique<Node>(s);
            }
        }
    }
    void visit(std::function<void(Node&,int)> func, TravType how, int level) {
        if (how == Prefix) {
            func(*this, level);
        }
        if (left) {
            left->visit(func, how, level+1);
        }
        if (how == Infix) {
            func(*this, level);
        }
        if (right) {
            right->visit(func, how, level+1);
        }
        if (how == Postfix) {
            func(*this, level);
        }
    }
    Node* find(const std::string& s) {
        int res = m_data.compare(s);
        if (res == 0) {
            return this;
         } else if (res < 0) {
            if (left) {
                return left->find(s);
            }
            return nullptr;
        } else {
            if (right) {
                return right->find(s);
            }
            return nullptr;
        }
    }
    ~Node() {
        std::cout << "destroying node " << m_data << std::endl;
    }
    std::unique_ptr<Node> left;
    std::unique_ptr<Node> right;
    std::string m_data;
};

struct Tree {
    std::unique_ptr<Node> root;
    void insert(const std::string& s) {
        if (root) {
            root->insert(s);
        } else {
            root = std::make_unique<Node>(s);
        }
    }
    void visit(std::function<void(Node&, int)> func, TravType how) {
        if (root) {
            root->visit(func, how, 0);
        }
    }
    Node* find(const std::string& s) {
        if (root) {
            return root->find(s);
        } else {
            return nullptr;
        }
    }

};


int main() {
    Tree t;
    t.insert("2");
    t.insert("-1");
    t.insert("44");
    t.insert("2");
    t.insert("hello");
    t.insert("10");
    t.insert("0");
    t.visit([](Node& n, int level) { n.m_data += " (" + std::to_string(level) + ")"; }, Infix);
    t.visit([](const Node& n, int level) { std::cout << n.data() << std::endl; }, Infix);
    Node *n = t.find("2");
    if (n != nullptr) {
        std::cout << "found " << n->data() << std::endl;
    }
    t.visit([](const Node& n, int level) { std::cout << n.data() << ": " << level << std::endl; }, Prefix);
}

